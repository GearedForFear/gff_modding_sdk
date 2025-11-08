class_name Gun
extends Spatial


export var projectile_values: Resource
export var cooldown_timer: NodePath

var on_cooldown := false
var particles_set: int = 0


func _enter_tree():
	get_node(cooldown_timer).connect("timeout", self, "_on_Timer_timeout")
	var particles_root: Spatial = get_node_or_null("ParticlesRoot")
	if particles_root != null:
		var gles3: bool = OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3
		for set in particles_root.get_children():
			for particles in set.get_children():
				if particles.name.ends_with("CPU") == gles3:
					DeletionManager.add_to_stack(particles)


func try_shoot(shooter: CombatVehicle, pools: Node) -> bool:
	if on_cooldown or projectile_values.RESOURCE_TYPE == \
			ProjectileValues.ResouceTypes.AMMO \
			and shooter.ammo <= projectile_values.ammo_cost:
		return false
	shoot(shooter, pools)
	return true


func shoot(shooter: CombatVehicle, pools: Node):
	match projectile_values.RESOURCE_TYPE:
		ProjectileValues.ResouceTypes.AMMO:
			shooter.ammo -= projectile_values.ammo_cost
	
	var new_projectile: Projectile
	match projectile_values.projectile_type:
		ProjectileValues.ProjectileTypes.MISSILE:
			match projectile_values.movement_type:
				ProjectileValues.MovementTypes.STRAIGHT:
					new_projectile = pools.get_straight_missile()
				ProjectileValues.MovementTypes.STATIC_TARGET:
					new_projectile = pools.get_homing_missile()
					new_projectile.movement_type\
							= ProjectileValues.MovementTypes.STATIC_TARGET
					new_projectile.target = $Target.global_translation
				ProjectileValues.MovementTypes.DYNAMIC_TARGET:
					new_projectile = pools.get_homing_missile()
					new_projectile.movement_type\
							= ProjectileValues.MovementTypes.DYNAMIC_TARGET
				ProjectileValues.MovementTypes.REMOTE:
					new_projectile = pools.get_homing_missile()
					new_projectile.movement_type\
							= ProjectileValues.MovementTypes.REMOTE
					new_projectile.target = $Target.global_translation
					shooter.missiles.append(new_projectile)
	
	new_projectile.start(global_transform, projectile_values.damage,
			projectile_values.reward, projectile_values.burn, shooter)
	start_cooldown()
	
	var particles_root: Spatial = get_node_or_null("ParticlesRoot")
	if particles_root != null:
		var set: Spatial = particles_root.get_child(particles_set)
		for n in set.get_children():
			n.restart()
			n.emitting = true
		particles_set = (particles_set + 1) % particles_root.get_child_count()


func start_cooldown():
	on_cooldown = true
	get_node(cooldown_timer).start()


func _on_Timer_timeout():
	on_cooldown = false
