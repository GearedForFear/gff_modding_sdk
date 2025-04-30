extends AspectRatioContainer


func _ready():
	yield(get_tree(), "idle_frame")
	var root = get_node("/root")
	get_parent().remove_child(self)
	root.add_child(self)
