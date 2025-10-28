class_name Gun
extends Spatial


export var projectile_values: Resource
export var cooldown_timer: NodePath

var on_cooldown := false


func _enter_tree():
	get_node(cooldown_timer).connect("timeout", self, "_on_Timer_timeout")


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
					new_projectile = pools.get_straight_missile()
	
	new_projectile.start(global_transform, projectile_values.damage,
			projectile_values.reward, projectile_values.burn, shooter)
	start_cooldown()


func start_cooldown():
	on_cooldown = true
	get_node(cooldown_timer).start()


func _on_Timer_timeout():
	on_cooldown = false
