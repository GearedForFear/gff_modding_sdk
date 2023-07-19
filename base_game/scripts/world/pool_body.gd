extends DynamicShadowBody


onready var deletion_manager: Node = get_node("../../../DeletionManager")


var pool: Array


func start(global_transform: Transform):
	self.global_transform = global_transform
	linear_velocity = Vector3.ZERO
	angular_velocity = Vector3.ZERO
	collision_layer = 4
	collision_mask = 6
	set_physics_process(true)
	set_process(true)
	show()
	reset_physics_interpolation()
	deletion_manager.other_rigid_bodies.append(self)


func stop():
	collision_layer = 0
	collision_mask = 0
	set_physics_process(false)
	set_process(false)
	hide()
	pool.append(self)
