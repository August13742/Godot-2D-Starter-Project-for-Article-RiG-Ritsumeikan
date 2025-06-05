@tool
extends Control
class_name RadialMenu

@export var outer_radius:int = 256
@export var outer_fill_colour:Color
@export var inner_radius: int = 80
@export var inner_slice_radius:int = 128
@export var inner_fill_colour:Color
@export var outline_width:float = 4
@export var line_colour:Color
@export var num_slices: int = 3
@export var offset_angle_deg:float = 45:
	set(num):
		offset_angle_deg = num
		offset_angle_rad = deg_to_rad(num)
var offset_angle_rad:float = deg_to_rad(offset_angle_deg)
@export var slice_seperation:float = 4
var slices:Array[RadialMenuSlice] = []
func _draw() -> void:
	draw_circle(Vector2.ZERO,outer_radius,outer_fill_colour,true,-1,true)
	#draw_circle(Vector2.ZERO,inner_radius-outline_width*2,inner_fill_colour,true,-1,true)
	for i in range(num_slices):
		var per_slice_rad:float = TAU / num_slices
		var left:int = clamp(i,0,num_slices)
		var right:int = clamp(i+1,0,num_slices)
		var slice:RadialMenuSlice = RadialMenuSlice.new(
			per_slice_rad*left-offset_angle_rad,
			per_slice_rad*right-offset_angle_rad,
			inner_slice_radius,
			outer_radius,
			line_colour,
			slice_seperation,
			line_colour)

		slices.append(slice)
		self.add_child(slice)
		var slice_material:ShaderMaterial = ShaderMaterial.new()
		slice_material.shader = load("res://UI/RadialMenu/flash.gdshader")
		slice_material.set_shader_parameter("flash_colour",Vector3(randf(),randf(),randf()))
		slice_material.set_shader_parameter("flash_duration",0.5)
		slice.material = slice_material
		slice.queue_redraw()






class RadialMenuSlice:
	extends Control
	var rad_from:float
	var rad_to:float

	var from_direction:Vector2
	var to_direction:Vector2

	var inner_radius:float
	var outer_radius:float
	var total_rad:float
	var arc_colour:Color
	var line_width:float
	var line_colour:Color
	func _init(_rad_from,_rad_to,_inner_radius,_outer_radius,_line_colour,_line_width,_arc_colour) -> void:
		self.rad_from = _rad_from
		self.rad_to = _rad_to
		self.total_rad = rad_to+rad_from
		self.inner_radius = _inner_radius
		self.outer_radius = _outer_radius
		self.from_direction = Vector2.from_angle(_rad_from)
		self.to_direction = Vector2.from_angle(_rad_to)
		self.arc_colour = _arc_colour
		self.line_colour = _line_colour
		self.line_width = _line_width
	func _draw()->void:
		draw_arc(Vector2.ZERO,inner_radius,rad_from,rad_to,128,arc_colour,line_width,true)
		draw_arc(Vector2.ZERO,outer_radius,rad_from,rad_to,128,arc_colour,line_width,true)
		draw_line(from_direction*inner_radius,from_direction*outer_radius,line_colour,line_width,true)
		draw_line(to_direction*inner_radius,to_direction*outer_radius,line_colour,line_width,true)
