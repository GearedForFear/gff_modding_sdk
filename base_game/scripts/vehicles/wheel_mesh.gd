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
	rotate(transform.basis.x.normalized(), gameplay_wheel.get_rpm()
			* Global.extrapolation_manager.wheel_extrapolation_factor)


func update_blur(factor: float):
	var blur: float = ease(abs(gameplay_wheel.get_rpm()) * factor, 3)
	get_active_material(0).set_shader_param("blur", blur)
