class_name Gun
extends Spatial


export var projectile_values: Resource

var cooldown: int = 0
var particles_set: int = 0


func _enter_tree():
	set_physics_process(false)
	var particles_root: Spatial = get_node_or_null("ParticlesRoot")
	if particles_root != null:
		var gles3: bool = OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3
		for set in particles_root.get_children():
			for particles in set.get_children():
				if particles.name.ends_with("CPU") == gles3:
					DeletionManager.add_to_garbage(particles)


func _physics_process(_delta):
	cooldown -= 1
	if cooldown == 0:
		set_physics_process(false)


func try_shoot(shooter: CombatVehicle) -> bool:
	if cooldown != 0 or projectile_values.RESOURCE_TYPE == \
			ProjectileValues.ResouceTypes.AMMO \
			and shooter.ammo <= projectile_values.ammo_cost:
		return false
	shoot(shooter)
	return true


func shoot(shooter: CombatVehicle) -> Projectile:
	match projectile_values.RESOURCE_TYPE:
		ProjectileValues.ResouceTypes.AMMO:
			shooter.change_ammo(-projectile_values.ammo_cost)
	
	var return_value: Projectile
	match projectile_values.projectile_type:
		ProjectileValues.ProjectileTypes.CHAINSAW:
			return_value = Pools.get_chainsaw()
		ProjectileValues.ProjectileTypes.MISSILE:
			match projectile_values.movement_type:
				ProjectileValues.MovementTypes.STRAIGHT:
					return_value = Pools.get_straight_missile()
				ProjectileValues.MovementTypes.STATIC_TARGET:
					return_value = Pools.get_homing_missile()
					return_value.movement_type\
							= ProjectileValues.MovementTypes.STATIC_TARGET
					return_value.target = $Target.global_translation
				ProjectileValues.MovementTypes.DYNAMIC_TARGET:
					return_value = Pools.get_homing_missile()
					return_value.movement_type\
							= ProjectileValues.MovementTypes.DYNAMIC_TARGET
				ProjectileValues.MovementTypes.REMOTE:
					return_value = Pools.get_homing_missile()
					return_value.movement_type\
							= ProjectileValues.MovementTypes.REMOTE
					return_value.target = $Target.global_translation
					shooter.missiles.append(return_value)
		ProjectileValues.ProjectileTypes.GRENADE:
			return_value = Pools.get_grenade()
		ProjectileValues.ProjectileTypes.BUZZSAW:
			return_value = Pools.get_buzzsaw()
			shooter.saws.append(return_value)
	
	return_value.start(global_transform, projectile_values.damage,
			projectile_values.reward, projectile_values.burn, shooter)
	start_cooldown()
	
	var particles_root: Spatial = get_node_or_null("ParticlesRoot")
	if particles_root != null:
		var set: Spatial = particles_root.get_child(particles_set)
		for n in set.get_children():
			n.restart()
			n.emitting = true
		particles_set = (particles_set + 1) % particles_root.get_child_count()
	
	return return_value


func start_cooldown():
	cooldown = projectile_values.cooldown - 1
	set_physics_process(true)
