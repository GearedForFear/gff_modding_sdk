class_name DeletionManager
extends Node


const TO_DELETE := Array()
const RIGID_BODIES := Array()

var delete: bool = true

onready var max_rigid_bodies: int \
		= get_node("/root/RootControl/SettingsManager").max_rigid_bodies


func _process(_delta):
	if delete:
		for _n in range(min(5, TO_DELETE.size())):
			var next_deletion: Node = TO_DELETE.pop_back()
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
					TO_DELETE.append(delete_body)
					delete_body.get_parent().remove_child(delete_body)


static func get_this() -> DeletionManager:
	return Global.root_control.get_node("DeletionManager") as DeletionManager


static func add_to_stack(to_delete: Node):
	get_this().TO_DELETE.append(to_delete)


static func add_array_to_stack(to_delete: Array):
	get_this().TO_DELETE.append_array(to_delete)
