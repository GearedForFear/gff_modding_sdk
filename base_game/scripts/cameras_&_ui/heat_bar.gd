extends ProgressBar


func _physics_process(_delta):
	var heat: float = get_node("../../../../../..").heat
	value = heat
	if heat < 25.0:
		$Description.text = ""
	elif heat < 50.0:
		$Description.text = tr("HOT")
	elif heat < 75.0:
		$Description.text = tr("INFERNAL")
	else:
		$Description.text = tr("HELLFIRE_UNIVERSE")
