extends CanvasLayer


@onready var start: Button = $MarginContainer4/VBoxContainer/Start
@onready var quit: Button = $MarginContainer4/VBoxContainer/Quit




func _ready() -> void:
	start.pressed.connect(_on_start_pressed)
	quit.pressed.connect(_on_quit_pressed)

	
func _on_start_pressed()->void:
	get_tree().change_scene_to_file("uid://d25txupl55glj")
	
	queue_free.call_deferred()
	
func _on_quit_pressed()->void:
	get_tree().quit()
