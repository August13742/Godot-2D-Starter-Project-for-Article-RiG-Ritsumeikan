class_name State
## enter, update, handle_input(event)
extends Node


var root_entity:Node3D
var animation_player:AnimationPlayer

func set_root(entity: Node3D) -> void:
	root_entity = entity
	animation_player = root_entity.animation_player
	
func enter():
	pass

func update(_delta: float):
	pass

func exit():
	pass

func handle_input(_event: InputEvent):
	pass



func can_dash() -> bool:
	return true  # default: all states can dash


func jump():
	root_entity.velocity.y = root_entity.jump_force
	root_entity.state_machine.change_state("Airbourne")
