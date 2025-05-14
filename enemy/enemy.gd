extends Node2D

@export var max_health:int = 200
@export var damage:int = 2

@onready var jump_cd: Timer = $JumpCD
@onready var action_timer: Timer = $ActionTimer

@onready var hitbox_component: HitboxComponent = $HitboxComponent

@onready var sprite:Sprite2D = $Sprite2D

@onready var red_sprite: Sprite2D = $Sprite2D/Red_Sprite

@onready var health_component: HealthComponent = $HealthComponent
@onready var hurtbox_component: HurtboxComponent = $HurtboxComponent
@export var action_cd:float = 1

@onready var hitbox: CollisionShape2D = $HitboxComponent/Hitbox

var jump_height := 150
@export var jump_cooldown:float = 2
@export_range(0,2) var jump_cooldown_deviation_range:float = 1
@onready var target = get_tree().get_first_node_in_group("player")
var can_jump:bool = true
var can_perform_action:bool = true

@onready var sprite_material:ShaderMaterial = sprite.material
@onready var bubble_scene:PackedScene = preload("uid://bfd6624nvv6t8")
#const PROJECTILE_DIRECTIONS_RIGHT = [ ## but with y reversed because + is down
	#Vector2(1.000, 0.000),   # 0°
	#Vector2(0.906, -0.423),   # 25°
	#Vector2(0.643, -0.766),   # 50°
#]
#const PROJECTILE_DIRECTIONS_LEFT = [
	#Vector2(-1.000,  0.000),    # 180°
	#Vector2(-0.906,  -0.423),    # 155°
	#Vector2(-0.643,  -0.766),    # 130°
#]
const PROJECTILE_DIRECTIONS_RIGHT = [
	Vector2(1.000, 0.000),    # 0°
	Vector2(0.966, -0.259),    # 15°
	Vector2(0.866, -0.500),    # 30°
]
const PROJECTILE_DIRECTIONS_LEFT = [
	Vector2(-1.000,  0.000),    # 180°
	Vector2(-0.966,  -0.259),    # 165°
	Vector2(-0.866,  -0.500),    # 150°
]
@onready var foreground_layer:Node2D = get_tree().get_first_node_in_group("foreground_layer")
func _ready():
	jump_cd.timeout.connect(_on_jump_timer_timeout)
	health_component.max_health = max_health
	health_component.full_heal()
	hitbox_component.damage = damage

	action_timer.wait_time = action_cd
	action_timer.timeout.connect(on_action_timer_timeout)

	health_component.received_damage.connect(_on_damaged)



func bubble_attack():
	if sprite.flip_h:
		for i in range (3):
				var bubble:Node2D = bubble_scene.instantiate()
				foreground_layer.add_child(bubble)
				bubble.direction = PROJECTILE_DIRECTIONS_LEFT[i]
				bubble.global_position = self.global_position
				await get_tree().create_timer(0.5 * (i+1)).timeout
	else:
		for i in range (3):
				var bubble:Node2D = bubble_scene.instantiate()
				foreground_layer.add_child(bubble)
				bubble.direction = PROJECTILE_DIRECTIONS_RIGHT[i]
				bubble.global_position = self.global_position
				await get_tree().create_timer(0.5 * (i+1)).timeout

	action_timer.start(action_cd)

func on_action_timer_timeout():
	can_perform_action = true


func determine_action():
	var rand_num:float = randf()
	if rand_num < 0.6:
		trigger_jump()

	else:
		bubble_attack()
		can_perform_action = false

func trigger_jump():
	if can_jump:
		jump_tween()
		hitbox.set_deferred("disabled",true)
		can_jump = false

func jump_tween():
	var tween1 = create_tween()

	tween1.tween_property(self,"scale",Vector2(1.5,1.5),0.75).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.parallel()
	tween1.tween_property(sprite,"position:y",sprite.position.y - jump_height,0.75)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

	tween1.parallel()

	tween1.tween_property(self,"global_position",target.global_position,0.75)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

	tween1.parallel()
	tween1.tween_method(
		func(value:Vector2): sprite_material.set_shader_parameter("deform", value),
		Vector2(0.0,1.0),
		Vector2(0.0,8.0),
		0.75).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween1.parallel()
	tween1.tween_method(
		func(value:Vector2): sprite_material.set_shader_parameter("offset", value),
		Vector2(-5.0,85.0),
		Vector2(-20.0,-10.0),
		0.75).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

	tween1.tween_callback(tween_2)


func tween_2():
	var tween2 = create_tween()
	var move_time := 0.5
	var drop_time := 0.25
	var total_time:= move_time + drop_time
	var offset_direction:float = Input.get_action_strength("right") - Input.get_action_strength("left")
	var offset_multiplier:= 125
	var target_position :Vector2= target.global_position
	var aim_position:Vector2 = Vector2(offset_direction * offset_multiplier + target_position.x, target_position.y)

	tween2.tween_property(self,"global_position",aim_position,move_time)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

	tween2.tween_property(sprite,"position:y",0,drop_time)\
	.set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween2.parallel()
	tween2.tween_method(
		func(value:Vector2): sprite_material.set_shader_parameter("deform", value),
		Vector2(0.0,8.0),
		Vector2(0.0,1.0),
		drop_time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)
	tween2.parallel()
	tween2.tween_method(
		func(value:Vector2): sprite_material.set_shader_parameter("offset", value),
		Vector2(-20.0,-10.0),
		Vector2(-5.0,85.0),
		drop_time).set_ease(Tween.EASE_IN_OUT).set_trans(Tween.TRANS_EXPO)

	tween2.tween_property(self, "scale",Vector2(1,1),0.25)


	tween2.tween_callback(_tween_callback)

	await get_tree().create_timer(move_time*1.2).timeout
	hitbox.disabled = false
	await get_tree().create_timer(total_time*0.05).timeout
	EventSystem.emit_trigger_camera_shake()


func _tween_callback():
	var wait_time:float = jump_cooldown + randf_range(jump_cooldown-jump_cooldown_deviation_range,jump_cooldown+jump_cooldown_deviation_range)
	jump_cd.start(wait_time)
	can_jump = true
	action_timer.start(action_cd)

func _process(_delta: float) -> void:
	sprite.flip_h = true if (target.global_position.x - self.global_position.x) < 0 else false
	red_sprite.flip_h = true if sprite.flip_h else false
	if can_perform_action: determine_action()

func _on_jump_timer_timeout():
	can_jump = true

func _on_damaged():
	red_sprite.visible = true
	await get_tree().create_timer(0.15).timeout
	red_sprite.visible = false
