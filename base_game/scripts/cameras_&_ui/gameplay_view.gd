extends Control


const aspect_ratios := PoolRealArray([
		# 2 players:
		-1.0, -1.0, -1.0, -1.0, 2.0,
		# 3 players:
		-1.0, -1.0, -1.0, 3.0, 1.0,
		# 4 players:
		-1.0, -1.0, 4.0, 4.0, 1.0,
		# 5 players:
		-1.0, 5.0, 5.0, 1.5, 0.66,
		# 6 players:
		6.0, 6.0, 6.0, 1.5, 0.66
])


func set_views(cameras: Array):
	for n in get_children():
		n.queue_free()
	for n in cameras:
		var container: ViewportContainer = n.get_node("../..")
		container.get_parent().remove_child(container)
		add_child(container)
	var containers: Array = get_children()
	if containers.size() == 0:
		return
	update_containers()


func update_containers():
	var containers: Array = get_children()
	var container_amount: int = containers.size()
	if container_amount == 0:
		return
	var aspect_ratio: float = OS.window_size.x / OS.window_size.y
	var array_offset: int = (container_amount - 2) * 5
	
	var columns: int = container_amount
	while columns > 1:
		if aspect_ratio >= aspect_ratios[6 - columns + array_offset]:
			break
		columns -= 1
	var rows: int = container_amount / columns
	if rows * columns != container_amount:
		rows += 1
	var row_size: float = 1.0 / rows
	
	for r in rows:
		if container_amount < (r + 1) * columns:
			columns = container_amount % columns
		var column_size: float = 1.0 / columns
		for c in columns:
			var container: ViewportContainer = containers.pop_front()
			container.anchor_left = column_size * c
			container.anchor_right = column_size * (c + 1)
			container.anchor_top = row_size * r
			container.anchor_bottom = row_size * (r + 1)
			#container.stretch_shrink = SettingsManager.get_this().resolution
			#container.get_node("Viewport").set_size_override(true, container.rect_size)
			#container.rect_size = rect_size
			#container.rect_scale = Vector2.ONE
			#container.set_margins_preset(Control.PRESET_WIDE)
			#var re = Rect2(Vector2.ZERO, rect_size)
			#v.set_attach_to_screen_rect(re)
			#VisualServer.viewport_set_active(v.get_viewport_rid(), true)
			#container.margin_right = rect_size.x
			#container.margin_bottom = rect_size.y
			#container.get_node("Viewport").size = container.rect_size
			#container.rect_min_size = rect_size


func _on_Current_item_rect_changed():
	update_containers()
