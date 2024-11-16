extends Particles


func start(global_transform: Transform):
	self.global_transform = global_transform
	rotation.z = randi() / TAU
	reset_physics_interpolation()
	emitting = true


func _on_Particles_finished():
	get_node("../..").sparks_available.append(self)
