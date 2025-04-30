extends ShadowSetter


export var mirror: bool = false

onready var gameplay_wheel: VehicleWheel = get_node(skeleton)


func update_transform(body_transform: Transform, wheel_scale: float):
	global_transform = body_transform
	scale = Vector3(wheel_scale, wheel_scale, wheel_scale)
	if mirror:
		scale = -scale
	translation = gameplay_wheel.translation
	rotation = gameplay_wheel.rotation
