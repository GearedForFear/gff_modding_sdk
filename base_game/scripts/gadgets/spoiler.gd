extends MeshInstance


enum AnimationStates {IN, OUT, MOVING_IN, MOVING_OUT}

export var gadget_resource: Resource

var animation_state: int = AnimationStates.IN


func use(vehicle: CombatVehicle, enable: bool):
	var wheels := [vehicle.get_node("WheelFrontLeft"),
			vehicle.get_node("WheelFrontRight"),
			vehicle.get_node("WheelBackLeft"),
			vehicle.get_node("WheelBackRight")]
	if enable:
		for n in wheels:
			n.wheel_friction_slip = gadget_resource.force
		if animation_state == AnimationStates.IN:
			$AnimationPlayer.play("in_out")
			animation_state = AnimationStates.MOVING_OUT
	else:
		for n in wheels:
			n.wheel_friction_slip = 2.0
		if animation_state == AnimationStates.OUT:
			$AnimationPlayer.play("out_in")
			animation_state = AnimationStates.MOVING_IN


func _on_AnimationPlayer_animation_finished(_anim_name):
	match animation_state:
		AnimationStates.MOVING_OUT:
			animation_state = AnimationStates.OUT
		AnimationStates.MOVING_IN:
			animation_state = AnimationStates.IN
