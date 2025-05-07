extends Node2D
class_name Player

@export var speed:int = 200

@onready var sprite:Sprite2D = $Sprite2D
@onready var front_img:Texture2D = preload("res://front.png")
@onready var side_img:Texture2D = preload("res://side.png")
@onready var back_img:Texture2D = preload("res://back.png")

func _ready() -> void:
	pass
	
var direction:Vector2 = Vector2.ZERO
func _process(_delta:float) -> void:
	direction = get_movement_vector()
	self.position += direction*speed*_delta
	if direction.y < 0:
		sprite.texture = back_img
	elif direction.y > 0:
		sprite.texture = front_img
	elif direction.x < 0:
		sprite.texture = side_img
		sprite.flip_h = false
	elif direction.x > 0:
		sprite.texture = side_img
		sprite.flip_h = true
		
func get_movement_vector() -> Vector2:
	var x_movement = Input.get_action_strength("right")-Input.get_action_strength("left")
	var y_movement = Input.get_action_strength("down") - Input.get_action_strength("up")
	return Vector2(x_movement,y_movement).normalized()
