class_name Glide
extends AnimationPlayer


func _enter_tree():
	set_physics_process(false)


func _physics_process(_delta):
	var vehicle: CombatVehicle = get_parent()
	var impulse_position: Vector3 = -vehicle.transform.basis.x \
			* vehicle.steer_target / 4
	var force: float = clamp(Vector2(vehicle.linear_velocity.x,
			vehicle.linear_velocity.z).length() - 20, 0, 10) * 3
	vehicle.apply_impulse(impulse_position, impulse_position +
			vehicle.transform.basis.y * force)
	vehicle.apply_torque_impulse(vehicle.transform.basis.y * force
			* vehicle.steer_target)


func toggle():
	var active = is_physics_processing()
	if active:
		play("out_in")
		get_node("../WingsOutAudio").play()
	else:
		play("in_out")
		get_node("../WingsInAudio").play()
	set_physics_process(not active)
