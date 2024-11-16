extends DynamicShadowBody


var pool: Array


func _physics_process(_delta):
	if global_translation.y <= -32:
		stop()


func start(global_transform: Transform):
	self.global_transform = global_transform
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	collision_layer = 4
	collision_mask = 18
	set_physics_process(true)
	set_process(true)
	show()
	reset_physics_interpolation()
	get_node("/root/RootControl/DeletionManager").rigid_bodies.append(self)


func stop():
	collision_layer = 0
	collision_mask = 0
	set_physics_process(false)
	set_process(false)
	hide()
	pool.append(self)
