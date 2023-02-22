extends Area


const Explosion: PackedScene = preload("res://scenes/destruction/explosion.tscn")

var damage: float
var reward: int
var burn: float
var shooter: CombatVehicle
var target: Vector3
var straight: bool
var moving_target: bool
var deletion_manager: Node
var gles3: bool


func _ready():
	set_as_toplevel(true)
	$Lifetime.wait_time *= 60.0 \
			/ ProjectSettings.get_setting("physics/common/physics_fps")
	$Lifetime.start()
	if get_node("/root/RootControl/SettingsManager").shadow_casters >= 4:
		$MeshInstance.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_ON
	$Particles.emitting = gles3
	$CPUParticles.emitting = !gles3


func _physics_process(_delta):
	translation += transform.basis.z * 0.5
	if not straight:
		global_transform = global_transform.interpolate_with(\
				global_transform.looking_at(target, Vector3.UP), 0.15)
		if moving_target:
			target = lerp(target, global_transform.origin - target.direction_to(\
					shooter.global_transform.origin), 0.7)
		else:
			target.y += 0.3


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
