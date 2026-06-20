class_name Destructible
extends Area


export var parts_path: String \
		= "res://scenes/destruction/rock_0_destroyed.tscn"
export var global_culling: bool = false
export var force_factor: float = 0.1 # This is applied twice in case of
									 # collision with a vehicle
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
	if not can_have_shadow:
		mesh.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
	shadow = mesh.cast_shadow == GeometryInstance.SHADOW_CASTING_SETTING_ON


func _exit_tree():
	DeletionManager.add_to_garbage(parts)


func destroy(_shooter: CombatVehicle, collision_object_translation_global: Vector3, force: float):
	if not destroyed:
		add_child(parts)
		var children: Array = parts.get_node("Bodies").get_children()
		for n in children:
			n.apply_central_impulse((n.global_transform.origin - collision_object_translation_global).normalized() * force * force_factor)
		DeletionManager.add_array_to_rigid_bodies(children)
		collision_layer = 0
		var mesh: MeshInstance = $MeshInstance
		mesh.get_node("StaticBody").collision_layer = 0
		destroyed = true
		set_process(false)
		DeletionManager.add_to_garbage(mesh)
		remove_child(mesh)


func _on_Area_body_entered(body: PhysicsBody):
	destroy(body, body.global_transform.origin, body.linear_velocity.length() * force_factor)
