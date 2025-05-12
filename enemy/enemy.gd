extends Node2D
@onready var timer: Timer = $Timer

@onready var area2D:Area2D = $Area2D
@onready var sprite:Sprite2D = $Sprite2D



var jump_height := 150
@onready var collision_shape_2d: CollisionShape2D = $Area2D/CollisionShape2D
@onready var target = get_tree().get_first_node_in_group("player")
var can_tween:bool = true

func _ready():
	area2D.body_entered.connect(_on_body_entered)
	timer.timeout.connect(_on_timer_timeout)
	


@onready var sprite_material:ShaderMaterial = sprite.material

func jump_tween():
	var tween1 = create_tween()
	
	tween1.tween_property(self,"scale",Vector2(1.5,1.5),1).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.tween_property(sprite,"position:y",sprite.position.y - jump_height,1)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	
	tween1.parallel()
	tween1.tween_method(
		func(value:Vector2): sprite_material.set_shader_parameter("deform", value),
		Vector2(0.0,1.0),
		Vector2(0.0,8.0),
		1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.parallel()
	tween1.tween_method(
		func(value:Vector2): sprite_material.set_shader_parameter("offset", value),
		Vector2(-5.0,85.0),
		Vector2(-20.0,-10.0),
		1.0).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
		
	tween1.tween_callback(tween_2)


func tween_2():
	var tween2 = create_tween()
	
	tween2.tween_property(self,"global_position",target.global_position,1)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	
	tween2.tween_property(sprite,"position:y",0,0.5)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween2.parallel()
	tween2.tween_method(
		func(value:Vector2): sprite_material.set_shader_parameter("deform", value),
		Vector2(0.0,8.0),
		Vector2(0.0,1.0),
		0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween2.parallel()
	tween2.tween_method(
		func(value:Vector2): sprite_material.set_shader_parameter("offset", value),
		Vector2(-20.0,-10.0),
		Vector2(-5.0,85.0),
		0.5).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	
	tween2.tween_property(self, "scale",Vector2(1,1),0.5)
	

	tween2.tween_callback(_tween_callback)
	
	await get_tree().create_timer(1.2).timeout
	collision_shape_2d.disabled = false
	await get_tree().create_timer(0.2).timeout
	EventSystem.emit_trigger_camera_shake()
	
	
func _tween_callback():
	timer.start()
	can_tween = true
	
func _process(_delta: float) -> void:
	sprite.flip_h = true if (target.global_position.x - self.global_position.x) < 0 else false
	

func _on_timer_timeout():
	
	if can_tween:
		jump_tween()
		collision_shape_2d.set_deferred("disabled",true)
		can_tween = false
	
func _on_body_entered(_other:Node2D):
	if can_tween:
		jump_tween()
		collision_shape_2d.set_deferred("disabled",true)
		can_tween = false
	
	

		
