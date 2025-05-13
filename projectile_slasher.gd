extends Area2D


var colliding:Array[Area2D]
func _ready() -> void:
	
	colliding = get_overlapping_areas()
	self.area_entered.connect(_on_area_entered)
	
	for obj in colliding:
		if "health_component" not in obj.owner:
			obj.owner.call_deferred("queue_free")
			
func _on_area_entered(other:Area2D):
	if "health_component" not in other.owner:
		other.owner.call_deferred("queue_free")
