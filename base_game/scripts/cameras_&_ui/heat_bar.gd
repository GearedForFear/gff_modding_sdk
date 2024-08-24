extends ProgressBar


func _physics_process(_delta):
	var heat: float = get_node("../../../../../..").heat
	value = heat
	if heat < 25.0:
		$Description.text = ""
	elif heat < 50.0:
		$Description.text = "Hot"
	elif heat < 75.0:
		$Description.text = "Infernal"
	else:
		$Description.text = "Hellfire Universe"
