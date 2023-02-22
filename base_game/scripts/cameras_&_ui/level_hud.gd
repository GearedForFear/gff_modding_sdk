extends Label


func _process(_delta):
	text = "Lv " + String(get_node("../../../../../..").level)
