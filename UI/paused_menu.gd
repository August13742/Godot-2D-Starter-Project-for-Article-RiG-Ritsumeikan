extends CanvasLayer


@onready var _continue: Button = $MarginContainer/VBoxContainer/Continue
@onready var quit: Button = $MarginContainer/VBoxContainer/Quit


func _ready() -> void:
	_continue.pressed.connect(_on_continue)
	quit.pressed.connect(_on_quit)

	AudioManager.fade_music()
	AudioManager.pause_sfx()
	get_tree().set_deferred("paused",true)
	
func _on_continue()->void:
	get_tree().paused = false
	AudioManager.unfade_music()
	AudioManager.resume_sfx()
	queue_free.call_deferred()
	
func _on_quit()->void:
	get_tree().quit()
