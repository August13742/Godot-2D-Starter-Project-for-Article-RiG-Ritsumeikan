class_name State
## enter, update, handle_input(event)
extends Node


var root_entity:Node2D
var animation_player:AnimatedSprite2D

func set_root(entity: Node2D) -> void:
	root_entity = entity
	animation_player = root_entity.animation_player
	
func enter():
	root_entity.debug_label.text = self.name

func update(_delta: float):
	pass

func exit():
	pass


func handle_input(_event: InputEvent):
	if _event.is_action_pressed("jump"):
		if can_jump():
			jump()
			
	if _event.is_action_pressed("dash"):
		if can_dash() && root_entity.can_dash:
			dash()
			
	if _event.is_action_pressed("shoot"):
		if can_shoot():
			shoot()



func can_dash() -> bool:
	return true  # default: all states can dash

func can_jump()->bool:
	return true

func can_shoot()->bool:
	return true

func jump():
	root_entity.velocity.y = -root_entity.jump_force
	root_entity.state_machine.change_state(StateMachine.Airbourne)

func dash():
	root_entity.state_machine.change_state(StateMachine.Dash)
	
func shoot():
	pass
