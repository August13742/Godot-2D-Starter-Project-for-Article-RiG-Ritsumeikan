extends CharacterBody2D


@export var normal_speed := 300
@export var sprint_speed := 500
@export var air_acceleration := 500.0
@export var ground_acceleration := 2000.0
@export var jump_force := 300
@export var gravity := 500
@export var terminal_fall_velocity := 1000.0
@export var dash_speed := 800
@export var dash_acceleration := 5000

@onready var visuals := $VisualControl

@onready var hurtbox_collision: CollisionShape2D = $HurtboxComponent/CollisionShape2D

@onready var state_machine := $StateMachine
@export var state_machine_debug:bool = false
@onready var sprite:AnimatedSprite2D = $VisualControl/AnimatedSprite2D
@onready var bullet_anchor:Node2D = $%BulletAnchor
@onready var animation_player:AnimatedSprite2D = $VisualControl/AnimatedSprite2D
@onready var debug_label:Label = $%StateLabel
@onready var dash_timer: Timer = $DashTimer
@onready var shoot_timer:Timer = $ShootTimer

@export var dash_cooldown:float = 5.0
@export var shoot_cooldown:float = 0.15
@export var bullet:= preload("res://bullet1.tscn")


var can_dash:bool = true
var can_shoot:bool = true
var shoot_hold:bool = false
var input_x:float = 0.

func _ready():
	debug_label.visible = true if state_machine_debug else false
	dash_timer.wait_time = dash_cooldown
	dash_timer.timeout.connect(reset_dash)
	shoot_timer.wait_time = shoot_cooldown
	shoot_timer.timeout.connect(reset_shoot)

func _physics_process(delta):
	input_x = Input.get_action_strength("right") - Input.get_action_strength("left")

	if input_x != 0:
		visuals.scale.x = -1 if input_x<0 else 1

	if input_x < 0 && bullet_anchor.position.x > 0:
		bullet_anchor.position.x *= -1

	state_machine.update(delta)


func _input(event):
	state_machine.handle_input(event)


func _unhandled_key_input(_event: InputEvent) -> void:
	pass

func reset_dash():
	can_dash = true

func reset_shoot():
	can_shoot = true


func shoot():
	var bullet_scene:Node2D = bullet.instantiate()
	bullet_anchor.add_child(bullet_scene)
	bullet_scene.direction = Vector2.LEFT if visuals.scale.x == -1 else Vector2.RIGHT
