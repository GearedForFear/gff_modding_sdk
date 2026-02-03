extends ProgressBar


func _ready():
	get_node("../../../../../../..").connect("acid_changed", self,
			"_on_acid_changed")


func _on_acid_changed(new: float, health: float, base_health: float):
	if new == 0.0 or health == 0.0:
		hide()
		return
	show()
	var red_health: float = health - new
	anchor_left = max(0.0, red_health) / base_health
	max_value = base_health - max(0.0, red_health)
	value = new + min(0.0, red_health)
