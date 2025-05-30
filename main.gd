extends Node


@onready var paused_menu_scene:PackedScene = preload("uid://cfld8aql8j84x")
func _ready():
	pass
	
func _input(event: InputEvent) -> void:
	if event.is_action_pressed("ui_cancel"): ## == "esc"
		self.add_child(paused_menu_scene.instantiate())
