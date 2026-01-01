extends Area


export var parts_path: String \
		= "res://scenes/destruction/rock_0_destroyed.tscn"
export var global_culling: bool = false
export var force_factor: float = 0.1
export var can_have_shadow: bool = true

var destroyed: bool = false
var parts: Spatial
var camera_count: int = 0
var shadow: bool


func _ready():
	parts = ResourceLoader.load(parts_path, "PackedScene").instance()
	var mesh: MeshInstance = $MeshInstance
	if global_culling:
		mesh.portal_mode = CullInstance.PORTAL_MODE_GLOBAL
		mesh.get_node("VisibilityNotifier").portal_mode = CullInstance.PORTAL_MODE_GLOBAL
	if not can_have_shadow:
		mesh.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
	shadow = mesh.cast_shadow == GeometryInstance.SHADOW_CASTING_SETTING_ON


func _exit_tree():
	DeletionManager.add_to_stack(parts)


func destroy(var position: Vector3, var force: float):
	if not destroyed:
		add_child(parts)
		var children: Array = parts.get_node("Bodies").get_children()
		for n in children:
			n.apply_central_impulse((n.global_transform.origin - position)\
					.normalized() * force * force_factor)
		DeletionManager.add_array_to_stack(children)
		collision_layer = 0
		var mesh: MeshInstance = $MeshInstance
		mesh.get_node("StaticBody").collision_layer = 0
		destroyed = true
		set_process(false)
		DeletionManager.add_to_stack(mesh)
		remove_child(mesh)


func _on_Area_body_entered(body):
	if body.is_in_group("combat_vehicle"):
		destroy(body.global_transform.origin, body.linear_velocity.length())


func _on_VisibilityNotifier_camera_entered(_camera):
	camera_count += 1
	if camera_count != 0:
		collision_layer = 4
		collision_mask = 1
		if shadow:
			$MeshInstance.cast_shadow \
					= GeometryInstance.SHADOW_CASTING_SETTING_ON


func _on_VisibilityNotifier_camera_exited(_camera):
	camera_count -= 1
	if camera_count == 0:
		collision_layer = 0
		collision_mask = 0
		$MeshInstance.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
