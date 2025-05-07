extends Node2D
@onready var timer: Timer = $Timer

@onready var area2D:Area2D = $Area2D
@onready var sprite:Sprite2D = $Sprite2D
var jump_step_size :=100
@onready var target = get_tree().get_first_node_in_group("player")
func _ready():
	area2D.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timer_timeout)
func jump_tween():

	var tween = create_tween().set_parallel(true)
	#tween.tween_method(tween_method,0.0,1.0,5)
	var direction_to_player = (target.global_position - self.global_position).normalized()
	tween.tween_property(self,"scale",Vector2(1.5,1.5),2).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween.tween_property(self,"position",self.position+direction_to_player*jump_step_size,2)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	
	
	
	tween.tween_callback(timer.start)
	
func _on_timer_timeout():
	self.scale = Vector2.ONE
	jump_tween()
	
func _on_body_entered(_other:Node2D):
	jump_tween()
	
	
func tween_method(progression:float):
	if(progression>=0.5):
		_random_motion()
		
func _random_motion():
	var viewport_size:Vector2 = get_viewport_rect().size
	self.position = Vector2(randf_range(50,viewport_size.x-50),randf_range(50,viewport_size.y-50))
	await get_tree().create_timer(0.05).timeout
