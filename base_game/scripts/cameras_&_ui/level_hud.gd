extends Label


func _ready():
	get_node("../../../../../..").connect("xp_changed", self, "_on_xp_changed")


func _on_xp_changed(_new: float, level: int):
	text = "Lv " + String(level)
