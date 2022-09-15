extends Node


var to_be_deleted: Array
var gameplay_rigid_bodies: Array
var other_rigid_bodies: Array

onready var max_rigid_bodies: int \
		= get_node("/root/RootControl/SettingsManager").max_rigid_bodies


func _process(_delta):
	var total_rigid_bodies: int = gameplay_rigid_bodies.size() \
			+ other_rigid_bodies.size()
	if total_rigid_bodies > max_rigid_bodies:
		for n in range(clamp(total_rigid_bodies - max_rigid_bodies, 0, \
				other_rigid_bodies.size()) - 1, -1, -1):
			var delete_body: RigidBody = other_rigid_bodies[n]
			delete_body.set_process(false)
			delete_body.set_physics_process(false)
			delete_body.hide()
			other_rigid_bodies.remove(n)
			to_be_deleted.append(delete_body)
	
	for n in to_be_deleted.size() / 30 + 1:
		if not to_be_deleted.empty():
			var next_deletion: Node = to_be_deleted[to_be_deleted.size() - 1]
			if(is_instance_valid(next_deletion)):
				next_deletion.queue_free()
			to_be_deleted.remove(to_be_deleted.size() - 1)
