extends AudioStreamPlayer3D


export var force_resource: Resource


func use(vehicle: CombatVehicle):
	if vehicle.get_node("WheelFrontLeft").is_in_contact() \
			or vehicle.get_node("WheelFrontRight").is_in_contact() \
			or vehicle.get_node("WheelBackLeft").is_in_contact() \
			or vehicle.get_node("WheelBackRight").is_in_contact():
		vehicle.apply_central_impulse(transform.basis.y * force_resource.force)
		if not playing or get_playback_position() > 0.3:
			play()
