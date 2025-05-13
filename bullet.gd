extends Node2D


@export var damage:int = 2
@export var projectile_speed:float = 2000
@export var direction:Vector2 = Vector2.RIGHT
var current_speed:float = 0
@onready var hitbox_component: Area2D = $HitboxComponent

func _ready() -> void:
	bullet_tween.call_deferred()

func bullet_tween()->void:
	var tween:Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BACK)
	tween.tween_method(
		func(value:float): current_speed = value,
		0,
		projectile_speed,
		0.75)

func _physics_process(delta: float) -> void:
	self.position += direction * current_speed * delta
