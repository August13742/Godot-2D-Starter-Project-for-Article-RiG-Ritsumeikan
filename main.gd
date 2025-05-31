extends Node


@onready var paused_menu_scene:PackedScene = preload("uid://cfld8aql8j84x")
@export var main_music_resource:MusicResource = preload("uid://cirgrmui22ggh")
func _ready():
	AudioManager.play_music(main_music_resource)
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): ## == "esc"
		self.add_child(paused_menu_scene.instantiate())
