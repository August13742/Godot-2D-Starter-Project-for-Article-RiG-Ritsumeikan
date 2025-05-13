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

func can_shoot(): return false
func can_dash(): return false
func can_jump(): return false
