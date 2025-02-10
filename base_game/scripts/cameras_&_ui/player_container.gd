class_name PlayerContainer
extends ViewportContainer


export var base_size: Vector2 = Vector2(640, 360)

var size_divisor: Vector2 = Vector2.ONE
var screen_position: Vector2 = Vector2.ZERO


func _enter_tree():
	var window_size: Vector2 = OS.window_size
	rect_size = window_size / size_divisor
	get_child(0).size = rect_size
	
	rect_scale = Vector2(clamp(base_size.x / window_size.x, base_size.y \
			/ window_size.y, 100), clamp(base_size.y / window_size.y, \
			base_size.x / window_size.x, 100))
	stretch_shrink = get_node("/root/RootControl/SettingsManager").resolution
	rect_position = OS.window_size * rect_scale * screen_position / size_divisor
	var viewport := $Viewport
	var target_size: Vector2 = viewport.size
	target_size.x = max(target_size.x, 40.0)
	target_size.y = max(target_size.y, 23.0)
	viewport.size = target_size
