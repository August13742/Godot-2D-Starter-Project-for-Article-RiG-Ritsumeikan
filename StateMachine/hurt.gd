extends State
class_name HurtState


var red_screen:Node
func enter():
	super()
	animation_player.play("hurt")
	red_screen = EventSystem.trigger_red_screen()
	get_tree().get_first_node_in_group("foreground_layer").add_child(red_screen)

func update(_delta: float):
	if !animation_player.is_playing(): owner.change_state(StateMachine.Idle)

func exit():
	red_screen.queue_free()

func handle_input(_event: InputEvent):
	pass

func can_shoot(): return false
func can_dash(): return false
func can_jump(): return false
