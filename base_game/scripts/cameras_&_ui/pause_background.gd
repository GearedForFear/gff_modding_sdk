extends ColorRect


func _enter_tree():
	yield(get_tree(), "idle_frame")
	call_deferred("update_size")


func update_size():
	rect_position.x = \
			get_node("../AspectRatioContainer/Control").rect_position.x
	rect_position.x += \
			get_node("../AspectRatioContainer/Control/Pause").rect_position.x
	rect_size.x = get_node("../AspectRatioContainer/Control/Pause").rect_size.x
