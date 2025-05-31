extends Node

# Pool of AudioStreamPlayer nodes for one-shot sounds
var _sfx_player_pool: Array[AudioStreamPlayer] = []
const SFX_PLAYER_POOL_SIZE: int = 10 # Adjust as needed
var _looping_sfx_players: Dictionary[StringName,AudioStreamPlayer] = {}
func _ready():
	self.process_mode = Node.PROCESS_MODE_ALWAYS
	_initialise_audio_pool()
	# load audio settings here from save file (save system not implemented yet)
	# and apply them to buses (e.g. Master, Music, SFX volumes).

func _initialise_audio_pool():
	for i in range(SFX_PLAYER_POOL_SIZE):
		var player = AudioStreamPlayer.new()
		add_child(player)
		_sfx_player_pool.append(player)

## Call to play a one-shot sound effect in SFX bus
func _play_one_shot_sfx(audio_stream: AudioStream, volume_linear: float = 1.0, pitch_scale: float = 1.0):
	# Find an available player in the pool
	for player in _sfx_player_pool:
		if not player.playing:
			player.stream = audio_stream
			player.volume_linear = volume_linear
			player.pitch_scale = pitch_scale
			player.bus = "SFX" # Ensure it plays on the SFX bus
			player.play()
			return

	# If no player is available then make new
	printerr("[AudioManager]: SFX pool exhausted for one-shots. Consider increasing SFX_PLAYER_POOL_SIZE.")
	var new_player = AudioStreamPlayer.new()
	add_child(new_player)
	new_player.stream = audio_stream
	new_player.volume_linear = volume_linear
	new_player.pitch_scale = pitch_scale
	new_player.bus = "SFX"
	new_player.play()
	new_player.finished.connect(func(): new_player.queue_free()) # Self-destruct after playing
	## or Add to pool for future use (can lead to large pool), remove line above
	#_sfx_player_pool.append(new_player) 
	## or add logic to shrink pool size during idle


## Call to play a sound effect. Can be one-shot or looped.
func play_sfx(resource: SFXResource)->void:
	var audio_stream: AudioStream = resource.stream
	var event_name: StringName = resource.event_name
	if resource.loop:
		# --- Looping SFX Logic ---
		# Stop and remove any existing looping sound with the same name to prevent duplicates
		# and allow restarting with new parameters if needed.
		if _looping_sfx_players.has(event_name):
			var existing_loop_player = _looping_sfx_players[event_name]
			if is_instance_valid(existing_loop_player):
				existing_loop_player.stop()
				existing_loop_player.queue_free()
			_looping_sfx_players.erase(event_name) # Remove from tracking

		## IMPORTANT: For looping to work, the AudioStream resource itself (e.g., .wav, .ogg)
		## MUST be imported into Godot with its loop property enabled
		var loop_player = AudioStreamPlayer.new()
		add_child(loop_player)
		loop_player.stream = audio_stream
		loop_player.volume_linear = resource.volume_linear
		loop_player.pitch_scale = resource.pitch_scale
		loop_player.bus = "SFX"
		
		loop_player.play()
		_looping_sfx_players[event_name] = loop_player # Track this looping player
	else:
		_play_one_shot_sfx(audio_stream, resource.volume_linear, resource.pitch_scale)

## Call to stop a specific looping sound effect
func stop_looped_sfx(resource:SFXResource, fade_out_duration: float = 0.0)->void:
	var sfx_name:StringName = resource.event_name
	if _looping_sfx_players.has(sfx_name):
		var player_to_stop = _looping_sfx_players[sfx_name]
		_looping_sfx_players.erase(sfx_name) # Remove from tracking immediately

		if not is_instance_valid(player_to_stop):
			# Player might have been freed already if stop_looped_sfx was called rapidly
			return

		if fade_out_duration > 0.001: # Check against a small epsilon for float comparison
			var tween = create_tween()
			tween.tween_property(player_to_stop, "volume_linear", 0.0, fade_out_duration)
			tween.tween_callback(func():
				if is_instance_valid(player_to_stop):
					player_to_stop.stop()
					player_to_stop.queue_free()
			)
		else:
			player_to_stop.stop()
			player_to_stop.queue_free()
	else:
		printerr("[AudioManager]: Attempted to stop non-existent or already stopped looping SFX: ", sfx_name)

var _paused_sfx_players:Array[AudioStreamPlayer] = []
func pause_sfx():
	_paused_sfx_players.clear()
	for player in _sfx_player_pool:
		if player.playing:
			player.stop()
			_paused_sfx_players.append(player)
	for player in _looping_sfx_players.values():
		if player.playing:
			player.stop()
			_paused_sfx_players.append(player)
func resume_sfx():
	for player in _paused_sfx_players:
		player.play()
	_paused_sfx_players.clear()
	
## Call to play music using the Music Bus
var _music_player: AudioStreamPlayer
func play_music(resource: MusicResource, fade_duration: float = 2.0):
	if not _music_player:
		_music_player = AudioStreamPlayer.new()
		add_child(_music_player)
		_music_player.bus = "Music"

	var audio_stream: AudioStream = resource.stream
	if audio_stream and _music_player.stream != audio_stream:
		## crossfading using Tween
		if _music_player.playing:
			# Fade out current
			var tween = create_tween()
			tween.tween_property(_music_player, "volume_linear", 0.0, fade_duration / 2.0)
			tween.tween_callback(func():
				_music_player.stop()
				_music_player.stream = audio_stream
				_music_player.play()
				# Fade in new
				var fade_in_tween = create_tween()
				fade_in_tween.tween_property(_music_player, "volume_linear", 1.0, fade_duration / 2.0)
			)
		else:
			_music_player.stream = audio_stream
			_music_player.volume_linear = 1.0 # Set to full volume immediately if no fading
			_music_player.play()

func stop_music(fade_duration: float = 1.5)->void:
	if _music_player and _music_player.playing:
		var tween = create_tween()
		tween.tween_property(_music_player, "volume_linear", 0.0, fade_duration)
		tween.tween_callback(_music_player.stop)
func resume_music(fade_duration: float = 1.5)->void:
	if _music_player and !_music_player.playing:
		var tween = create_tween()
		tween.tween_property(_music_player, "volume_linear", 1.0, fade_duration)
		tween.tween_callback(_music_player.play)
		
var _music_fade_tween: Tween
func fade_music(lower_threshold_linear: float = 0.2, fade_duration: float = 0.5):
	if not _music_player:
		return
	if _music_fade_tween and _music_fade_tween.is_running():
		_music_fade_tween.kill() # Prevent overlapping tweens
	
	_music_fade_tween = create_tween()

	_music_fade_tween.tween_property(_music_player, "volume_linear", lower_threshold_linear, fade_duration)
func unfade_music(fade_duration: float = 0.5):
	if not _music_player:
		return
	if _music_fade_tween and _music_fade_tween.is_running():
		_music_fade_tween.kill()
	
	_music_fade_tween = create_tween()
	_music_fade_tween.tween_property(_music_player, "volume_linear", 1.0, fade_duration)

	
# --- Bus Volume Control ---
func set_master_volume(volume_linear: float):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Master"), volume_linear)

func set_music_volume(volume_linear: float):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("Music"), volume_linear)

func set_sfx_volume(volume_linear: float):
	AudioServer.set_bus_volume_linear(AudioServer.get_bus_index("SFX"), volume_linear)
