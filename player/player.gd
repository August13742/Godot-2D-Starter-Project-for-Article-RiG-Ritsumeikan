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
@onready var animation_player:AnimatedSprite2D = $VisualControl/AnimatedSprite2D
@onready var debug_label:Label = $%StateLabel
@onready var dash_timer: Timer = $DashTimer
@export var dash_cooldown:float = 5.0
var can_dash:bool = true

var input_x:float = 0.
func _ready():
	debug_label.visible = true if state_machine_debug else false
	dash_timer.wait_time = dash_cooldown
	dash_timer.timeout.connect(reset_dash)
func _physics_process(delta):
	input_x = Input.get_action_strength("right") - Input.get_action_strength("left")
	sprite.flip_h = true if input_x<0 else false
	state_machine.update(delta)

func _input(event):
	state_machine.handle_input(event)


func _unhandled_key_input(_event: InputEvent) -> void:
	pass

func reset_dash():
	can_dash = true
