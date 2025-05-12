extends State
class_name AirbourneState

func enter():
	super()
	animation_player.play("jump")


func update(delta:float):
	var input_x:float = root_entity.input_x
	var speed:float = root_entity.sprint_speed if Input.is_action_pressed("sprint") else root_entity.normal_speed


	var accel:float = root_entity.air_acceleration
	root_entity.velocity.x = move_toward(root_entity.velocity.x, input_x * speed, accel * delta)
	root_entity.velocity.y = move_toward(root_entity.velocity.y, root_entity.terminal_fall_velocity, root_entity.gravity * delta)

	root_entity.move_and_slide()

	if root_entity.is_on_floor():
		animation_player.play("land")
		if input_x != 0:
			owner.change_state(StateMachine.Sprint if Input.is_action_pressed("sprint") else StateMachine.Walk)
		else:
			owner.change_state(StateMachine.Idle)

func can_jump() -> bool:
	return false  # disable jumping when airborne

func can_shoot() -> bool:
	return false 
	
func exit():
	pass
