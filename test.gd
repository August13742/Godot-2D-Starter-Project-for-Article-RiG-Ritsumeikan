extends Node




	
func print_await(delay:float):
	await get_tree().create_timer(delay).timeout
	print("hi%f"%delay)

func print_await_no_delay(count:int):
	await get_tree().create_timer(1).timeout
	print("hi no delay %d"%count)
	
func _ready():
	for i in range(5):
		print_await(i)
		print_await_no_delay(i)
	
	for j in range(10):
		await get_tree().create_timer(1).timeout
		print("coroutine in loop")
