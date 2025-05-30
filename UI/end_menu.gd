extends CanvasLayer
class_name EndMenu


@onready var label: Label = %Label
@onready var image: TextureRect = %Image

@export var victory_image_uid:String = "uid://b8mvhxfdlctyd"
@export var defeat_image_uid:String = "uid://cixg1laesmde3"



@onready var again: Button = $MarginContainer/VBoxContainer/Again
@onready var title: Button = $MarginContainer/VBoxContainer/Title
@onready var quit: Button = $MarginContainer/VBoxContainer/Quit

@export var main_scene_uid:String = "uid://d25txupl55glj"
@export var title_scene_uid:String = "uid://dvrtmh6s2mwog"
var is_victory:bool = false


func _ready() -> void:
	again.pressed.connect(_on_again)
	title.pressed.connect(_on_title)
	quit.pressed.connect(_on_quit)
	
	_late_init.call_deferred()
	
	
func _late_init()->void:
	if is_victory:
		label.text = "Victory!"
		image.texture = load(victory_image_uid)
	else:
		label.text = "Defeat:("
		image.texture = load(defeat_image_uid)


func _on_again()->void:
	get_tree().change_scene_to_file(main_scene_uid)
	self.queue_free()
	
	
func _on_title()->void:
	get_tree().change_scene_to_file(title_scene_uid)
	self.queue_free()
	
	
func _on_quit()->void:
	get_tree().quit()
	
