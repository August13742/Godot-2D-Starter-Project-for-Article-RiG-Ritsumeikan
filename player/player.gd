extends CharacterBody2D

@export var max_health:int = 20
@export var normal_speed := 300
@export var sprint_speed := 500
@export var air_acceleration := 500.0
@export var ground_acceleration := 2000.0
@export var jump_force := 300
@export var gravity := 500
@export var terminal_fall_velocity := 1000.0
@export var dash_speed := 800
@export var dash_acceleration := 5000
@onready var health_component: HealthComponent = $HealthComponent

@onready var visuals := $VisualControl

@onready var hurtbox_collision: CollisionShape2D = $HurtboxComponent/CollisionShape2D

@onready var state_machine := $StateMachine
@export var state_machine_debug:bool = false
@onready var sprite:AnimatedSprite2D = $VisualControl/AnimatedSprite2D
@onready var bullet_anchor:Node2D = $%BulletAnchor
@onready var animation_player:AnimatedSprite2D = $VisualControl/AnimatedSprite2D
@onready var debug_label:Label = $%StateLabel
@onready var dash_timer: Timer = $DashTimer

@export var dash_cooldown:float = 5.0
@export var shoot_cooldown:float = 0.5
@export var bullet:= preload("uid://sq2t0bfbhaar")
@export var sword_trail := preload("uid://bf6tsfypt3so")

var can_special:bool = true
var can_dash:bool = true

var shoot_hold:bool = false
var input_x:float = 0.
var last_faced_right:bool = true


func _ready():
	debug_label.visible = true if state_machine_debug else false
	dash_timer.wait_time = dash_cooldown
	dash_timer.timeout.connect(reset_dash)

	health_component.max_health = max_health
	health_component.full_heal()

	health_component.died.connect(EventSystem.player_died)
	

func _physics_process(delta):
	input_x = Input.get_action_strength("right") - Input.get_action_strength("left")

	if input_x != 0:
		last_faced_right = true if input_x > 0 else false
		sprite.flip_h = !last_faced_right
		bullet_anchor.position.x = -20 if !last_faced_right else 20


	state_machine.update(delta)

var shoot_time_elapsed:float = 0
func _process(delta: float) -> void:
	shoot_time_elapsed += delta
	if shoot_hold && shoot_time_elapsed >= shoot_cooldown:
		shoot()
		shoot_time_elapsed = 0


func _input(event):
	state_machine.handle_input(event)


func _unhandled_key_input(_event: InputEvent) -> void:
	pass

func reset_dash():
	can_dash = true



func shoot():
	if state_machine.current_state == state_machine.states[state_machine.Walk]:
		animation_player.play("walk_shoot")
	else:
		animation_player.play("stand_shoot")
	var bullet_scene:Node2D = bullet.instantiate()
	bullet_anchor.add_child(bullet_scene)
	if !last_faced_right:
		bullet_scene.direction = Vector2.LEFT
		bullet_scene.sprite.flip_h = true

func special():
	if state_machine.current_state == state_machine.states[state_machine.Idle]:
		animation_player.play("sword_slash")

	await get_tree().create_timer(0.2).timeout
	var sword_trail_scene:Node2D = sword_trail.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(sword_trail_scene)
	sword_trail_scene.global_position = self.global_position
	if !last_faced_right:
		sword_trail_scene.scale.x = -1
		sword_trail_scene.direction = Vector2.LEFT
	await get_tree().create_timer(1).timeout
	sword_trail_scene.call_deferred("queue_free")
