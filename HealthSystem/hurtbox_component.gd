extends Area2D
class_name HurtboxComponent

@onready var health_component:HealthComponent = owner.get_node("HealthComponent")
var floating_text_scene:PackedScene = preload("uid://wu77mlguuc7n")

func _ready():
	area_entered.connect(on_area_entered)
	
	
func on_area_entered(other_area:Area2D):
	if health_component == null: return
	if !(other_area is HitboxComponent): return
	
	var hitbox_component = other_area as HitboxComponent
	health_component.damaged(hitbox_component.damage)
	
	var floating_text:Node2D = floating_text_scene.instantiate()
	get_tree().get_first_node_in_group("foreground_layer").add_child(floating_text)
	
	floating_text.global_position = global_position
	floating_text.start("%.1f" % hitbox_component.damage)
	
	
