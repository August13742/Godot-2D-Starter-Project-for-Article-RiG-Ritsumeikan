extends Node


signal trigger_camera_shake

func emit_trigger_camera_shake():
	trigger_camera_shake.emit()

func trigger_red_screen() -> Node:
	var red_screen:CanvasLayer = load("uid://bwfy27hy7pu3p").instantiate()
	return red_screen



## ======END MENU HANDLING
var end_menu_scene:PackedScene = preload("uid://nb5plvk2y6dj")
func player_died()->void:
	var end_menu:EndMenu = end_menu_scene.instantiate()
	get_tree().get_current_scene().add_child(end_menu)
	end_menu.is_victory = false
	
func slime_died()->void:
	var end_menu:EndMenu = end_menu_scene.instantiate()
	get_tree().get_current_scene().add_child(end_menu)
	end_menu.is_victory = true
