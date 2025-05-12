extends State
class_name HurtState



func enter():
	super()
	animation_player.play("hurt")
	
func update(_delta: float):
	if !animation_player.is_playing(): owner.change_state(StateMachine.Idle)

func exit():
	pass

func handle_input(_event: InputEvent):
	pass
