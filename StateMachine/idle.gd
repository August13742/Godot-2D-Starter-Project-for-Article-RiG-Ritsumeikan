extends State
class_name IdleState


func enter():
	super()
	root_entity.velocity.x = 0

	if animation_player.animation == "land":
		return

	animation_player.play("idle")


func update(_delta:float):
	var input_x:float = root_entity.input_x
	if input_x != 0:
		if Input.is_action_pressed("sprint"):
			owner.change_state(StateMachine.Sprint)
		else:
			owner.change_state(StateMachine.Walk)
	if !root_entity.is_on_floor():
		owner.change_state(StateMachine.Airbourne)

	#if !animation_player.is_playing(): animation_player.play("idle")




func exit(): pass
