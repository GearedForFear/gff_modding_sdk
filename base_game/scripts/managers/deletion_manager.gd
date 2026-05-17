class_name DeletionManager
extends Node


signal start(remaining_deletions)

const GARBAGE := Array()
const RIGID_BODIES := Array()

var max_rigid_bodies: int


func _process(_delta):
	for _n in range(min(5, GARBAGE.size())):
		var next_deletion: Node = GARBAGE.pop_back()
		if(is_instance_valid(next_deletion)):
			next_deletion.queue_free()


func _physics_process(_delta):
	var total_rigid_bodies: int = RIGID_BODIES.size()
	if total_rigid_bodies > max_rigid_bodies:
		for _n in range(total_rigid_bodies - max_rigid_bodies):
			var delete_body: RigidBody = RIGID_BODIES.pop_front()
			if is_instance_valid(delete_body):
				if delete_body.is_in_group("pool_body"):
					delete_body.stop()
				else:
					delete_body.set_process(false)
					delete_body.set_physics_process(false)
					delete_body.hide()
					GARBAGE.append(delete_body)
					delete_body.get_parent().remove_child(delete_body)


static func get_this() -> DeletionManager:
	return Global.root_control.get_node("DeletionManager") as DeletionManager


static func enable(enable: bool):
	if enable:
		get_this().try_start()
	else:
		get_this().set_process(false)


func try_start():
	if GARBAGE.size() == 0:
		return
	set_process(true)
	emit_signal("start", Math.round_up(GARBAGE.size() / 5.0))


static func add_to_garbage(garbage: Node):
	GARBAGE.append(garbage)


static func add_array_to_garbage(garbage: Array):
	GARBAGE.append_array(garbage)


static func add_to_rigid_bodies(body: RigidBody):
	RIGID_BODIES.append(body)


static func add_array_to_rigid_bodies(bodies: Array):
	RIGID_BODIES.append_array(bodies)
