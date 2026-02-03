extends ProgressBar


export var connect_on_ready := true


func _ready():
	if connect_on_ready:
		connect_to_vehicle(get_node("../../../../../.."))


func connect_to_vehicle(body: CombatVehicle):
	body.connect("health_changed", self, "_on_health_changed")
	max_value = body.body_values.base_health


func _on_health_changed(new: float):
	value = new
	if value == max_value:
		modulate = Color(1, 1, 1, 0.5)
	else:
		modulate = Color(1, 1, 1, 1)
