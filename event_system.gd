extends Node


signal trigger_camera_shake

func emit_trigger_camera_shake():
	trigger_camera_shake.emit()

func trigger_red_screen() -> Node:
	var red_screen:CanvasLayer = load("uid://bwfy27hy7pu3p").instantiate()
	return red_screen
