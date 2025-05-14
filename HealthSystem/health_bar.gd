extends ProgressBar


@onready var health_component:HealthComponent = owner.get_node("HealthComponent")


func _ready():
	if health_component == null:
		push_error("Health Bar UI Requires Health Component, Which Cannot be Found on [%s]"%get_parent().name)
		
	health_component.health_changed.connect(on_health_changed)
	update_health_display()


func update_health_display():
	value = health_component.get_health_percent()
	
	
func on_health_changed():
	value = health_component.get_health_percent()
