extends ProgressBar


func _ready():
	get_node("../../../../../..").connect("ammo_changed", self,
			"_on_ammo_changed")


func _on_ammo_changed(new: float):
	value = new
	if new < 100.0:
		modulate = Color(1, 1, 1, 1)
		get_node("../Oversupply").hide()
	elif new == 100.0:
		modulate = Color(1, 1, 1, 0.5)
		get_node("../Oversupply").hide()
	else:
		modulate = Color(1, 1, 1, 0.5)
		var oversupply: ColorRect = get_node("../Oversupply")
		oversupply.show()
		oversupply.get_node("Label").text = String(new)
