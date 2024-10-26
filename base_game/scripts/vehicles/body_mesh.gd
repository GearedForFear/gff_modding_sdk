extends ShadowSetter


export var wheel_scale: float = 1.0


func _process(delta):
	global_transform = get_parent().get_global_transform_interpolated()
	for n in get_children():
		n.update_transform(global_transform, wheel_scale)
