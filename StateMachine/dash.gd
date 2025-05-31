extends State
class_name DashState



func enter():
	super()

	animation_player.play("dash")
	AudioManager.play_sfx(root_entity.dash_audio_resource)
	root_entity.hurtbox_collision.disabled = true
	root_entity.can_dash = false
	root_entity.dash_timer.start(root_entity.dash_cooldown)

func update(delta:float):
	var input_x:float = root_entity.input_x
	if !animation_player.is_playing():
		if !root_entity.is_on_floor():
			owner.change_state(StateMachine.Airbourne)
			return
		if input_x != 0:
			owner.change_state(StateMachine.Walk)
			return

		owner.change_state(StateMachine.Idle)
		return


	var accel:float = root_entity.dash_acceleration
	var speed:float = root_entity.dash_speed

	root_entity.velocity.x = move_toward(root_entity.velocity.x, input_x * speed, accel * delta)

	root_entity.move_and_slide()



func exit():
	root_entity.hurtbox_collision.disabled = false
	

func handle_input(_event: InputEvent):
	pass

func can_shoot():
	return false
