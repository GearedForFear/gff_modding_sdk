extends CPUParticles


func start(global_transform: Transform):
	self.global_transform = global_transform
	rotation.z = randi() / TAU
	reset_physics_interpolation()
	emitting = true
	$Timer.start()


func _on_Timer_timeout():
	get_node("../..").sparks_available.append(self)
