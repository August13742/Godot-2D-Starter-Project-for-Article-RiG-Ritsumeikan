extends Node


signal trigger_camera_shake

func emit_trigger_camera_shake():
	print("hello")
	trigger_camera_shake.emit()
