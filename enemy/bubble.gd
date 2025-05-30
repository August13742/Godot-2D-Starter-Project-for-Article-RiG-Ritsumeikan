extends Node2D


@export var damage:int = 2
@export var projectile_speed:float = randi_range(650,850)
@export var direction:Vector2 = Vector2.RIGHT
var current_speed:float = 0
@onready var hitbox_component: Area2D = $%HitboxComponent

func _ready() -> void:
	bullet_tween()

func bullet_tween()->void:
	var tween:Tween = create_tween()
	tween.set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_BOUNCE)
	tween.tween_method(
		func(value:float): current_speed = value,
		0,
		projectile_speed,
		randf_range(0.2,0.5))

	tween.tween_method(
		func(value:float): current_speed = value,
		projectile_speed,
		0,
		2).set_ease(Tween.EASE_OUT).set_trans(Tween.TRANS_CUBIC)

	tween.tween_callback(queue_free)

func _physics_process(delta: float) -> void:
	self.position += direction * current_speed * delta
