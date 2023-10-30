extends Area


export var parts_path: String \
		= "res://scenes/destruction/rock_0_destroyed.tscn"
export var global_culling: bool = false
export var force_factor: float = 0.1
export var can_have_shadow: bool = true

var destroyed: bool = false
var deletion_manager: Node
var parts: PackedScene
var visible_on: Array
var shadow: bool


func _ready():
	parts = ResourceLoader.load(parts_path, "PackedScene")
	if global_culling:
		$MeshInstance.portal_mode = CullInstance.PORTAL_MODE_GLOBAL
		$VisibilityNotifier.portal_mode = CullInstance.PORTAL_MODE_GLOBAL
	if not can_have_shadow:
		$MeshInstance.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
	shadow = $MeshInstance.cast_shadow \
			== GeometryInstance.SHADOW_CASTING_SETTING_ON


func destroy(var vehicle: CombatVehicle, var position: Vector3, \
		var force: float):
	if not destroyed:
		var new_parts: Spatial = parts.instance()
		add_child(new_parts)
		new_parts = new_parts.get_node("Bodies")
		for n in new_parts.get_children():
			var correct_transform = n.global_transform
			n.set_as_toplevel(true)
			new_parts.remove_child(n)
			vehicle.add_child(n)
			deletion_manager.other_rigid_bodies.append(n)
			n.global_transform = correct_transform
			n.apply_central_impulse((n.global_transform.origin - position)\
					.normalized() * force * force_factor)
		deletion_manager.to_be_deleted.append(new_parts)
		collision_layer = 0
		$MeshInstance/StaticBody.collision_layer = 0
		destroyed = true
		set_process(false)
		hide()


func _on_Area_body_entered(body):
	if body.is_in_group("combat_vehicle"):
		deletion_manager = body.deletion_manager
		destroy(body, body.global_transform.origin, \
				body.linear_velocity.length())


func _on_VisibilityNotifier_camera_entered(camera):
	visible_on.append(camera)
	if not visible_on.empty():
		collision_layer = 4
		collision_mask = 1
		if shadow:
			$MeshInstance.cast_shadow \
					= GeometryInstance.SHADOW_CASTING_SETTING_ON


func _on_VisibilityNotifier_camera_exited(camera):
	visible_on.erase(camera)
	if visible_on.empty():
		collision_layer = 0
		collision_mask = 0
		$MeshInstance.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
