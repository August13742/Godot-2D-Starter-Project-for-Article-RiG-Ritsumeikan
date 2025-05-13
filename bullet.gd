extends Node2D


@export var damage:int = 2
@export var projectile_speed:float = 2000
@export var direction:Vector2 = Vector2.RIGHT

@onready var hitbox_component: Area2D = $HitboxComponent
@onready var sprite: Sprite2D = $Bullet1
@onready var visible_on_screen_notifier_2d: VisibleOnScreenNotifier2D = $VisibleOnScreenNotifier2D



var current_speed:float = 0
func _ready() -> void:
	bullet_tween.call_deferred()
	visible_on_screen_notifier_2d.screen_exited.connect(queue_free)
	
	self.hitbox_component.damage = damage
	hitbox_component.area_entered.connect(on_area_entered)
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

func on_area_entered(other:Node2D):
	if other is HurtboxComponent:
		queue_free.call_deferred()
		
