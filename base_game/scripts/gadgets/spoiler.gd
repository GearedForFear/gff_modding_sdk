extends MeshInstance


export var gadget_resource: Resource


func use(vehicle: CombatVehicle, enable: bool):
	var wheels := [vehicle.get_node("WheelFrontLeft"),
			vehicle.get_node("WheelFrontRight"),
			vehicle.get_node("WheelBackLeft"),
			vehicle.get_node("WheelBackRight")]
	if enable:
		for n in wheels:
			n.wheel_friction_slip = gadget_resource.force
	else:
		for n in wheels:
			n.wheel_friction_slip = 2.0
