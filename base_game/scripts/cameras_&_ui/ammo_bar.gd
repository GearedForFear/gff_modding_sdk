extends ProgressBar


func _ready():
	get_node("../../../../../..").connect("ammo_changed", self,
			"_on_ammo_changed")


func _on_ammo_changed(new: float):
	value = new
	if value == 100.0:
		modulate = Color(1, 1, 1, 0.5)
	else:
		modulate = Color(1, 1, 1, 1)
