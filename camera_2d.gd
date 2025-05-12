extends Camera2D
## Higher Means higher Initial Camera Acceleration Growth
@export var damping_factor:float = 20

## Defaults to Player if not Manually Set
@export var target:Node


var target_position = Vector2.ZERO


func _ready() -> void:
	make_current()
	if target == null: 
		target = get_tree().get_first_node_in_group("player")
		print_debug("[Debug/Referencing]: Target not Manually Set, Defaulting Camera Target to Player")
		if target == null:
			print_debug("[Debug/Referencing]: Cannot Find Player")
	EventSystem.trigger_camera_shake.connect(_on_trigger_camera_shake)		


var shake_time := 0.0
var shake_duration := 0.0
var shake_strength := 0.0


func _process(delta: float) -> void:
	if target == null: return
	target_position = target.global_position
	global_position = global_position.lerp(
		target_position, (1.0-exp(-delta*damping_factor)))
		
	if shake_time > 0.0:
		shake_time -= delta
		var decay = shake_time / shake_duration
		var max_offset = shake_strength * decay
		offset = offset + Vector2(
		randf_range(-1.0, 1.0),
		randf_range(-1.0, 1.0)
		) * max_offset
	else:
		offset = offset.lerp(
		Vector2.ZERO, (1.0-exp(-delta*damping_factor)))

func shake(duration: float = 0.3, strength: float = 35.0):
	shake_time = duration
	shake_duration = duration
	shake_strength = strength
	
func _on_trigger_camera_shake():
	shake()
