extends Node2D

@onready var area2D:Area2D = $Area2D
@onready var sprite:Sprite2D = $Sprite2D


func _ready():
	area2D.body_entered.connect(_on_body_entered)

func _on_body_entered(_other:Node2D):
	var tween = create_tween()
	tween.tween_method(tween_method,0.0,1.0,5)
	tween.parallel()
	tween.tween_property(self,"scale",Vector2(3.0,3.0),5)
	tween.parallel()
	tween.tween_property(sprite,"modulate",Color(1,0,0),5)
	tween.tween_callback(queue_free)
	
func tween_method(progression:float):
	if(progression>=0.5):
		_random_motion()
		
func _random_motion():
	var viewport_size:Vector2 = get_viewport_rect().size
	self.position = Vector2(randf_range(50,viewport_size.x-50),randf_range(50,viewport_size.y-50))
	await get_tree().create_timer(0.05).timeout
