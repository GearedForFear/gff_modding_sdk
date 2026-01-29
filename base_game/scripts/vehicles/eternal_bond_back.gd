extends AmmoVehicle


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
		if Input.is_action_pressed(controls.weapon_back):
			if $Launcher.try_shoot(self, pools):
				other_half.ammo = ammo


func shoot():
	if master_body:
		pass#ammo -= missile_ammo_cost
	else:
		pass#other_half.ammo -= missile_ammo_cost


func damage(amount: float, _reward: int, _burn: float, shooter: VehicleBody) \
		-> int:
	if alive and shooter != other_half and shooter != get_node("../.."):
		health -= amount
		if health <= 0:
			if shooter == null:
				health = 0
			else:
				var payout: int = kill(10, shooter)
				if other_half.alive:
					get_node("../RespawnTimer").stop()
				else:
					get_node("../..").alive = false
				return payout
	return 0


func _on_RespawnTimer_timeout():
	$DeathParticles.emitting = false
	other_half.get_node("DeathParticles").emitting = false
	var parent_body: AmmoVehicle = get_node("../..")
	parent_body.split(false)
	parent_body.alive = true
	parent_body.health = body_values.base_health * 2
	gameplay_manager.respawn(parent_body)
