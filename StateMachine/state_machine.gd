extends Node
class_name StateMachine


var current_state:State
var states := {}

@onready var root_entity:CharacterBody2D = owner

enum {
	Idle,
	Walk,
	Sprint,
	Airbourne,
	Hurt,
	Dash
}
func _ready():
	states[Idle] = $Idle
	states[Walk] = $Walk
	states[Sprint] = $Sprint
	states[Airbourne] = $Airbourne

	states[Hurt] = $Hurt
	states[Dash] = $Dash

	for state in states.values():
		state.call_deferred("set_root",root_entity)


	change_state.call_deferred(StateMachine.Idle)

	late_init.call_deferred()

func late_init():
	root_entity.health_component.received_damage.connect(_on_received_damage)

func change_state(state: int):
	if current_state:
		current_state.exit()
	current_state = states.get(state)
	if current_state:
		current_state.enter()

func update(delta: float):
	if current_state:
		current_state.update(delta)

func handle_input(event: InputEvent):
	if current_state:
		current_state.handle_input(event)

func _on_received_damage():
	change_state(StateMachine.Hurt)
