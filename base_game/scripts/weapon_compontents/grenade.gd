extends Area


const Explosion: PackedScene = preload("res://scenes/destruction/explosion.tscn")

export var speed: float = 0.8

var damage: float
var reward: int
var burn: float
var shooter: CombatVehicle
var deletion_manager: Node

var interpolation_weight: float = 0.01


func _ready():
	set_as_toplevel(true)
	$Lifetime.wait_time *= 60.0 \
			/ ProjectSettings.get_setting("physics/common/physics_fps")
	$Lifetime.start()
	if get_node("/root/RootControl/SettingsManager").shadow_casters >= 4:
		$MeshInstance.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_ON


func _physics_process(_delta):
	translation += transform.basis.z * speed
	transform.basis.z = transform.basis.z.linear_interpolate(Vector3.DOWN, 0.01)
	interpolation_weight *= 1.1


func _on_Lifetime_timeout():
	set_process(false)
	hide()
	deletion_manager.to_be_deleted.append(self)


func _on_Area_body_entered(body):
	if body != shooter:
		if true:
			$RayCast.force_raycast_update()
			var new_explosion: Area = Explosion.instance()
			new_explosion.damage = damage
			new_explosion.reward = reward
			new_explosion.burn = burn
			new_explosion.shooter = shooter
			new_explosion.deletion_manager = deletion_manager
			body.add_child(new_explosion)
			new_explosion.global_transform = global_transform
			new_explosion.global_transform.origin \
					= $RayCast.get_collision_point()
			if $RayCast.get_collision_point() == Vector3.ZERO:
				new_explosion.global_transform.origin = global_transform.origin
		set_process(false)
		hide()
		deletion_manager.to_be_deleted.append(self)
