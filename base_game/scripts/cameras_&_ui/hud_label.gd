extends Label


func _ready():
	connect("resized", self, "_on_Label_resized")
	yield(get_tree(), "idle_frame")
	update_size()


func _on_Label_resized():
	update_size()


func update_size():
	var viewport_scale: Vector2 = get_viewport_rect().size / Vector2(640, 360)
	var smaller: float = min(viewport_scale.x, viewport_scale.y)
	match align:
		ALIGN_LEFT:
			rect_scale = Vector2(smaller, smaller)
		ALIGN_CENTER:
			pass
		ALIGN_RIGHT:
			pass
