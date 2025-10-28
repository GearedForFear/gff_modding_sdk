class_name MonsterTruckSteering
extends Object


static func use(wheels: Array, steer_left: bool, steer_right: bool):
	var steer_target = 0.0
	if steer_left:
		steer_target = 1.0
	if steer_right:
		steer_target -= 1.0
	steer_target *= CombatVehicle.STEER_LIMIT
	var steering: float = wheels[0].steering
	for n in wheels:
		n.steering = move_toward(steering, steer_target,
				CombatVehicle.STEER_SPEED)
