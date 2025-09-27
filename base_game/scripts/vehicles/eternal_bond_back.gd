extends AmmoVehicle


export var missile_damage: float = 40.0
export var missile_reward: int = 15
export var missile_burn: float = 10.0
export var missile_ammo_cost: float = 10.0

var can_shoot: bool = false
var other_half: AmmoVehicle


func _ready():
	set_as_toplevel(true)


func _physics_process(_delta):
	if master_body:
		$CameraBase/Camera/AspectRatioContainer/Control/Resources/HealthBarTop\
			.value = other_half.health
		$CameraBase/Camera/AspectRatioContainer/Control/Resources/HealthBarBottom\
			.value = health
	else:
		ammo = other_half.ammo
		
	if alive:
		if can_shoot and ammo >= missile_ammo_cost \
				and Input.is_action_pressed(controls.weapon_back):
			shoot()


func shoot():
	can_shoot = false
	get_node("../MissileTimer").start()
	
	var new_missile: StraightProjectile = pools.get_straight_missile()
	new_missile.start($ShotPosition.global_transform, missile_damage, \
			missile_reward, missile_burn, self)
	if master_body:
		ammo -= missile_ammo_cost
	else:
		other_half.ammo -= missile_ammo_cost


func damage(amount: float, _reward: int, _burn: float, shooter: VehicleBody) \
		-> int:
	if alive and shooter != other_half and shooter != get_node("../.."):
		health -= amount
		if health <= 0:
			if shooter == null:
				health = 0
			else:
				var payout: int = kill(10)
				if other_half.alive:
					get_node("../RespawnTimer").stop()
				else:
					get_node("../..").alive = false
				return payout
	return 0


func _on_MissileTimer_timeout():
	can_shoot = true


func _on_RespawnTimer_timeout():
	$DeathParticles.emitting = false
	other_half.get_node("DeathParticles").emitting = false
	var parent_body: AmmoVehicle = get_node("../..")
	parent_body.split(false)
	parent_body.alive = true
	parent_body.health = base_health * 2
	gameplay_manager.respawn(parent_body)
