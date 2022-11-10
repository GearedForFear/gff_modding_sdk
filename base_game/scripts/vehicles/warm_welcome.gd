extends AmmoVehicle


const Bullet: PackedScene \
		= preload("res://scenes/weapon_components/bullet.tscn")
const CartridgeCase: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_case.tscn")
const CartridgeLink: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_link.tscn")
const Money: PackedScene = preload("res://scenes/collectables/money.tscn")

export var bullet_damage: float = 2.0
export var bullet_reward: int = 1
export var bullet_burn: float = 0.2
export var bullet_ammo_cost: float = 2.0

export var flamethrower_damage: float = 1.0
export var flamethrower_reward: int = 1
export var flamethrower_burn: float = 1.0
export var flamethrower_push: int = 250
export var flamethrower_ammo_cost: float = 0.12

export var jump_force: int = 300

var can_shoot: bool = true


func _ready():
	if controls == null:
		driver_name = "Warm Welcome"
	if get_node("/root/RootControl/SettingsManager").shadow_amount <= 1:
		$BodyMesh.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontLeft/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontRight/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackLeft/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackRight/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$GatlingGunLeft.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$GatlingGunRight.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF


func _physics_process(_delta):
	if alive:
		if controls == null:
			var left_collider: PhysicsBody = $ShotPositionLeft.get_collider()
			var right_collider: PhysicsBody = $ShotPositionRight.get_collider()
			if can_shoot and ammo >= bullet_ammo_cost and ((left_collider \
					!= null and left_collider.is_in_group("combat_vehicle") \
					and left_collider.score >= 100) or (right_collider != null \
					and right_collider.is_in_group("combat_vehicle") \
					and right_collider.score >= 100)):
				shoot(true)
				get_node("../StuckTimer").start()
			elif get_node("../GunTimer").is_stopped():
				shoot(false)
		else:
			if can_shoot and ammo >= bullet_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				shoot(true)
			elif get_node("../GunTimer").is_stopped():
				shoot(false)
			
			if Input.is_action_pressed(controls.weapon_back):
				jump()
			
			if ammo >= flamethrower_ammo_cost \
					and Input.is_action_pressed(controls.weapon_left):
				flame_left(true)
			else:
				flame_left(false)
			
			if ammo >= flamethrower_ammo_cost \
					and Input.is_action_pressed(controls.weapon_right):
				flame_right(true)
			else:
				flame_right(false)
	else:
		shoot(false)
		flame_left(false)
		flame_right(false)


func shoot(var b: bool):
	if b:
		get_node("../AnimationPlayer").play("gatling_gun_rotation")
		get_node("../AnimationPlayer").seek(0.0, false)
		ammo -= bullet_ammo_cost
		can_shoot = false
		get_node("../GunTimer").start()
		
		var new_bullet: Area = Bullet.instance()
		$ShotPositionLeft.add_child(new_bullet)
		new_bullet.damage = bullet_damage
		new_bullet.reward = bullet_reward
		new_bullet.burn = bullet_burn
		new_bullet.shooter = self
		new_bullet.deletion_manager = deletion_manager
		new_bullet = Bullet.instance()
		$ShotPositionRight.add_child(new_bullet)
		new_bullet.damage = bullet_damage
		new_bullet.reward = bullet_reward
		new_bullet.burn = bullet_burn
		new_bullet.shooter = self
		new_bullet.deletion_manager = deletion_manager
		
		var new_case: RigidBody = CartridgeCase.instance()
		$CartridgeExitLeft.add_child(new_case)
		new_case.set_as_toplevel(true)
		new_case.apply_central_impulse(new_case.transform.basis.x * 10)
		deletion_manager.other_rigid_bodies.append(new_case)
		new_case = CartridgeCase.instance()
		$CartridgeExitRight.add_child(new_case)
		new_case.set_as_toplevel(true)
		new_case.apply_central_impulse(new_case.transform.basis.x * 10)
		deletion_manager.other_rigid_bodies.append(new_case)
		
		var new_link: RigidBody = CartridgeLink.instance()
		$CartridgeExitLeft.add_child(new_link)
		new_link.set_as_toplevel(true)
		new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 - 10)\
				/ 10000, (new_case.transform.basis.x * -1 \
				+ new_link.transform.basis.y) * 4)
		deletion_manager.other_rigid_bodies.append(new_link)
		new_link = CartridgeLink.instance()
		$CartridgeExitRight.add_child(new_link)
		new_link.set_as_toplevel(true)
		new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 - 10)\
				/ 10000, (new_case.transform.basis.x \
				+ new_link.transform.basis.y) * 4)
		deletion_manager.other_rigid_bodies.append(new_link)
		
		if gles3:
			$MuzzleFlashLeft.emitting = true
			$MuzzleFlashRight.emitting = true
		else:
			$CPUMuzzleFlashLeft.emitting = true
			$CPUMuzzleFlashRight.emitting = true
	else:
		if gles3:
			$MuzzleFlashLeft.emitting = false
			$MuzzleFlashRight.emitting = false
		else:
			$CPUMuzzleFlashLeft.emitting = false
			$CPUMuzzleFlashRight.emitting = false


func jump():
	if $WheelFrontLeft.is_in_contact() or $WheelFrontRight.is_in_contact() or \
			$WheelBackLeft.is_in_contact() or $WheelBackRight.is_in_contact():
		apply_central_impulse(transform.basis.y * jump_force)


func flame_left(var b: bool):
	if b:
		apply_central_impulse(transform.basis.x * -flamethrower_push)
		ammo -= flamethrower_ammo_cost
		deal_flame_damage($FlameDamageFrontLeft)
		deal_flame_damage($FlameDamageBackLeft)
		
		if gles3:
			$FlamethrowerParticlesFrontLeft.emitting = true
			$FlamethrowerParticlesBackLeft.emitting = true
		else:
			$FlamethrowerCPUParticlesFrontLeft.emitting = true
			$FlamethrowerCPUParticlesBackLeft.emitting = true
	else:
		if gles3:
			$FlamethrowerParticlesFrontLeft.emitting = false
			$FlamethrowerParticlesBackLeft.emitting = false
		else:
			$FlamethrowerCPUParticlesFrontLeft.emitting = false
			$FlamethrowerCPUParticlesBackLeft.emitting = false


func flame_right(var b: bool):
	if b:
		apply_central_impulse(transform.basis.x * flamethrower_push)
		ammo -= flamethrower_ammo_cost
		deal_flame_damage($FlameDamageFrontRight)
		deal_flame_damage($FlameDamageBackRight)
		
		if gles3:
			$FlamethrowerParticlesFrontRight.emitting = true
			$FlamethrowerParticlesBackRight.emitting = true
		else:
			$FlamethrowerCPUParticlesFrontRight.emitting = true
			$FlamethrowerCPUParticlesBackRight.emitting = true
	else:
		if gles3:
			$FlamethrowerParticlesFrontRight.emitting = false
			$FlamethrowerParticlesBackRight.emitting = false
		else:
			$FlamethrowerCPUParticlesFrontRight.emitting = false
			$FlamethrowerCPUParticlesBackRight.emitting = false


func deal_flame_damage(var a: Area):
	for n in a.get_overlapping_bodies():
		if n != self:
			var payout: int = n.damage(flamethrower_damage, \
					flamethrower_reward, flamethrower_burn, self)
			if payout > 0:
				var new_money: Area = Money.instance()
				new_money.shooter = self
				new_money.reward = payout
				new_money.deletion_manager = deletion_manager
				new_money.speed_divisor = 2
				n.add_child(new_money)
				new_money.global_transform.origin = a.global_transform.origin \
						+ a.global_transform.basis.x * 2


func _on_GunTimer_timeout():
	can_shoot = true
