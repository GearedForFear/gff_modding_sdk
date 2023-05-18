extends AmmoVehicle


const Missile: PackedScene \
		= preload("res://scenes/weapon_components/missile.tscn")

export var missile_damage: float = 40.0
export var missile_reward: int = 15
export var missile_burn: float = 10.0
export var missile_ammo_cost: float = 10.0

var can_shoot: bool = false
var other_half: AmmoVehicle


func _ready():
	set_as_toplevel(true)


func _physics_process(_delta):
	if alive:
		ammo = other_half.ammo
		if controls == null:
			pass
		else:
			if can_shoot and ammo >= missile_ammo_cost \
					and Input.is_action_pressed(controls.weapon_back):
				shoot()
	
	if master_body:
		$CameraBase/Camera/AspectRatioContainer/Control/Resources/HealthBarTop\
			.value = other_half.health
		$CameraBase/Camera/AspectRatioContainer/Control/Resources/HealthBarBottom\
			.value = health


func shoot():
	can_shoot = false
	get_node("../MissileTimer").start()
	
	var new_missile: Area = Missile.instance()
	new_missile.damage = missile_damage
	new_missile.reward = missile_reward
	new_missile.burn = missile_burn
	new_missile.shooter = self
	new_missile.straight = true
	new_missile.deletion_manager = deletion_manager
	new_missile.gles3 = gles3
	$ShotPosition.add_child(new_missile)
	
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
				alive = false
				apply_central_impulse(transform.basis.y * 900)
				get_node("../AnimationPlayer").play("death")
				var payout: int = score / 10
				score -= payout
				acid_duration = 0
				acid_cause = null
				if gles3:
					$DeathParticles.emitting = true
				else:
					$DeathCPUParticles.emitting = true
				if other_half.alive:
					pass
				else:
					get_node("../..").alive = false
					get_node("../RespawnTimer").start()
				return payout
	return 0


func reward(amount: int):
	score += amount
	other_half.score = score
	health = clamp(health + amount, 0.0, base_health)
	acid_duration = 0
	acid_cause = null
	if controls == null:
		get_node("../StuckTimer").start()


func _on_MissileTimer_timeout():
	can_shoot = true


func _on_RespawnTimer_timeout():
	if gles3:
		$DeathParticles.emitting = false
		other_half.get_node("DeathParticles").emitting = false
	else:
		$DeathCPUParticles.emitting = false
		other_half.get_node("DeathCPUParticles").emitting = false
	var parent_body: AmmoVehicle = get_node("../..")
	parent_body.split(false)
	parent_body.alive = true
	parent_body.health = base_health * 2
	gameplay_manager.respawn(parent_body)
