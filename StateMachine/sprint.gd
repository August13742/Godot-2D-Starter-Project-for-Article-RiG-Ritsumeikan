extends State
class_name SprintState


func enter():
	super()
	animation_player.play("sprint")
	AudioManager.play_sfx(root_entity.sprint_audio_resource)


func update(delta:float):
	var input_x:float = root_entity.input_x
	if input_x == 0:
		owner.change_state(StateMachine.Idle)
		return
	if !root_entity.is_on_floor():
		owner.change_state(StateMachine.Airbourne)
		return
	if Input.is_action_just_released("sprint"):
		owner.change_state(StateMachine.Walk)
		return


	var accel:float = root_entity.ground_acceleration
	var speed:float = root_entity.sprint_speed

	root_entity.velocity.x = move_toward(root_entity.velocity.x, input_x * speed, accel * delta)


	root_entity.move_and_slide()
	root_entity.apply_floor_snap()

func exit()->void:
	AudioManager.stop_looped_sfx(root_entity.sprint_audio_resource)
	
func can_shoot():
	return false
