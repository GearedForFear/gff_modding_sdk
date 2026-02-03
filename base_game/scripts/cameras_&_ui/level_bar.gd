extends ProgressBar


func _ready():
	get_node("../../../../../..").connect("xp_changed", self, "_on_xp_changed")


func _on_xp_changed(new: float, _level: int):
	value = new
