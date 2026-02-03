extends ProgressBar


func _ready():
	get_node("../../../../../..").connect("heat_changed", self,
			"_on_heat_changed")


func _on_heat_changed(new: float):
	value = new
	if value < 25.0:
		$Description.text = ""
	elif value < 50.0:
		$Description.text = tr("HOT")
	elif value < 75.0:
		$Description.text = tr("INFERNAL")
	else:
		$Description.text = tr("HELLFIRE_UNIVERSE")
