extends Area


func _physics_process(_delta):
	for n in get_overlapping_bodies():
		var impulse_factor: float = 200.0
		if not n.is_in_group("combat_vehicle"):
			impulse_factor = n.weight / 10
		n.apply_central_impulse((n.global_translation - global_translation \
				* Vector3(1, 0, 1)).normalized().rotated(Vector3.UP, -PI / 2) \
				* impulse_factor)
