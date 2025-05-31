extends Button

@export var hover_sound_resource:SFXResource = preload("uid://d4bu6gix5u45")
@export var pressed_sound_resource:SFXResource = preload("uid://b5efmh1qdopx3")

func _ready() -> void:
	mouse_entered.connect(_on_mouse_entered)
	button_down.connect(_on_button_down)
	
func _on_mouse_entered()->void:
	AudioManager.play_sfx(hover_sound_resource)
	
func _on_button_down()->void:
	AudioManager.play_sfx(pressed_sound_resource)
