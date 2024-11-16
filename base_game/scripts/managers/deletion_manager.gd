extends Node


var to_be_deleted: Array
var rigid_bodies: Array
var delete: bool = true

onready var max_rigid_bodies: int \
		= get_node("/root/RootControl/SettingsManager").max_rigid_bodies


func _process(_delta):
	if delete:
		for _n in range(min(5, to_be_deleted.size())):
			var next_deletion: Node = to_be_deleted.pop_back()
			if(is_instance_valid(next_deletion)):
				next_deletion.queue_free()


func _physics_process(_delta):
	var total_rigid_bodies: int = rigid_bodies.size()
	if total_rigid_bodies > max_rigid_bodies:
		for _n in range(total_rigid_bodies - max_rigid_bodies):
			var delete_body: RigidBody = rigid_bodies.pop_front()
			if is_instance_valid(delete_body):
				if delete_body.is_in_group("pool_body"):
					delete_body.stop()
				else:
					delete_body.set_process(false)
					delete_body.set_physics_process(false)
					delete_body.hide()
					to_be_deleted.append(delete_body)
					delete_body.get_parent().remove_child(delete_body)
