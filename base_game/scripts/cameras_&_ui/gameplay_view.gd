extends Control


const ASPECT_RATIOS := PoolRealArray([
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
const DEFAULT_ASPECT_RATIO: float = 16.0 / 9.0


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
		if aspect_ratio >= ASPECT_RATIOS[6 - columns + array_offset]:
			break
		columns -= 1
	var rows: int = container_amount / columns
	if rows * columns != container_amount:
		rows += 1
	var row_size: float = 1.0 / rows
	
	var new_size = Vector2(640, 360)
	var window_size: Vector2 = OS.window_size
	var window_aspect_ratio: float = window_size.x / window_size.y
	if (window_aspect_ratio > DEFAULT_ASPECT_RATIO):
		new_size.x *= window_aspect_ratio / DEFAULT_ASPECT_RATIO
	else:
		new_size.y *= DEFAULT_ASPECT_RATIO / window_aspect_ratio
	
	var window_scale: Vector2 = window_size / Vector2(640, 360)
	var screen_scale: float = min(window_scale.x, window_scale.y)
	rect_size = new_size * screen_scale
	
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
			container.rect_scale = Vector2(1 / screen_scale, 1 / screen_scale)
			container.stretch_shrink = SettingsManager.get_this().resolution


func _on_Current_item_rect_changed():
	update_containers()
