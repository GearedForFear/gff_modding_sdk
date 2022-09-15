class_name PlayerContainer
extends ViewportContainer


export var base_size: Vector2 = Vector2(640, 360)

var size_divisor: Vector2 = Vector2.ONE
var screen_position: Vector2 = Vector2.ONE


func _enter_tree():
	var window_size: Vector2 = OS.window_size
	rect_size = window_size / size_divisor
	get_child(0).size = rect_size
	
	rect_scale = Vector2(clamp(base_size.x / window_size.x, base_size.y \
			/ window_size.y, 100), clamp(base_size.y / window_size.y, \
			base_size.x / window_size.x, 100))
	stretch_shrink = get_node("/root/RootControl/SettingsManager").resolution
	rect_position = base_size - base_size * screen_position / size_divisor
