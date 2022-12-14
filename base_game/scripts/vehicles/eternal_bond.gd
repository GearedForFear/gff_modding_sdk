extends AmmoVehicle


const Bullet: PackedScene \
		= preload("res://scenes/weapon_components/bullet.tscn")
const CartridgeCase: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_case.tscn")
const CartridgeLink: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_link.tscn")

export var bullet_damage: float = 2.5
export var bullet_reward: int = 1
export var bullet_burn: float = 0.25
export var bullet_ammo_cost: float = 2.5

export var shotgun_damage: float = 4.0
export var shotgun_reward: int = 1
export var shotgun_burn: float = 0.4
export var shotgun_ammo_cost: float = 8.0
export var shotgun_blast: float = 2000.0

var can_shoot_lmg: bool = true
var can_shoot_shotgun_left: bool = true
var can_shoot_shotgun_right: bool = true
var together: bool = true

onready var front_half: Spatial \
		= preload("res://scenes/vehicles/eternal_bond_front.tscn").instance()
onready var back_half: Spatial \
		= preload("res://scenes/vehicles/eternal_bond_back.tscn").instance()


func _ready():
	if controls == null:
		driver_name = "Eternal Bond"
	if get_node("/root/RootControl/SettingsManager").shadow_amount <= 1:
		$BodyMesh.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$BodyMesh2.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontLeft/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontRight/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackLeft/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackRight/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontLeft2/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontRight2/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackLeft2/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackRight2/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
	
	var body: AmmoVehicle = front_half.get_child(0)
	body.controls = controls
	body.track = track

	body = back_half.get_child(0)
	body.controls = controls
	body.track = track

	body.other_half = front_half.get_child(0)
	front_half.get_child(0).other_half = body
	add_child(front_half)
	add_child(back_half)


func _physics_process(_delta):
	if alive:
		if controls == null:
			var left_collider: PhysicsBody = $ShotPositionLeft.get_collider()
			var right_collider: PhysicsBody = $ShotPositionRight.get_collider()
			if can_shoot_lmg and ammo >= bullet_ammo_cost and ((left_collider \
					!= null and left_collider.is_in_group("combat_vehicle") \
					and left_collider.score >= 100) or (right_collider != null \
					and right_collider.is_in_group("combat_vehicle") \
					and right_collider.score >= 100)):
				shoot(true)
				get_node("../StuckTimer").start()
			elif get_node("../MachineGunTimer").is_stopped():
				shoot(false)
		else:
			if can_shoot_lmg and ammo >= bullet_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				shoot(true)
			elif get_node("../MachineGunTimer").is_stopped():
				shoot(false)
			if can_shoot_shotgun_left and ammo >= shotgun_ammo_cost \
					and Input.is_action_pressed(controls.weapon_left):
				shoot_left()
			if can_shoot_shotgun_right and ammo >= shotgun_ammo_cost \
					and Input.is_action_pressed(controls.weapon_right):
				shoot_right()
			if together and Input.is_action_pressed(controls.weapon_back):
				split(true)
			if not together and Input.is_action_pressed(controls.respawn):
				split(false)
	else:
		shoot(false)


func shoot(var b: bool):
	if b:
		can_shoot_lmg = false
		get_node("../MachineGunTimer").start()

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

		ammo -= bullet_ammo_cost

		if gles3:
			$MuzzleFlashMGLeft.emitting = true
			$MuzzleFlashMGRight.emitting = true
		else:
			$CPUMuzzleFlashMGLeft.emitting = true
			$CPUMuzzleFlashMGRight.emitting = true
	else:
		if gles3:
			$MuzzleFlashMGLeft.emitting = false
			$MuzzleFlashMGRight.emitting = false
		else:
			$CPUMuzzleFlashMGLeft.emitting = false
			$CPUMuzzleFlashMGRight.emitting = false


func shoot_left():
	ammo -= shotgun_ammo_cost
	can_shoot_shotgun_left = false
	get_node("../ShotgunTimerLeft").start()
	
	apply_impulse(transform.basis.z * 2.5, transform.basis.x * -shotgun_blast)
	
	var shot_positions: Array = $ShotgunPositionFrontLeft.get_children()
	shot_positions.append_array($ShotgunPositionBackLeft.get_children())
	for n in shot_positions:
		var new_bullet: Area = Bullet.instance()
		n.add_child(new_bullet)
		new_bullet.damage = shotgun_damage
		new_bullet.reward = shotgun_reward
		new_bullet.burn = shotgun_burn
		new_bullet.shooter = self
		new_bullet.deletion_manager = deletion_manager
	
	if gles3:
		$MuzzleFlashShotgunFrontLeft.emitting = true
		$MuzzleFlashShotgunBackLeft.emitting = true
	else:
		$CPUMuzzleFlashShotgunFrontLeft.emitting = true
		$CPUMuzzleFlashShotgunBackLeft.emitting = true


func shoot_right():
	ammo -= shotgun_ammo_cost
	can_shoot_shotgun_right = false
	get_node("../ShotgunTimerRight").start()
	
	apply_impulse(transform.basis.z * 2.5, transform.basis.x * shotgun_blast)
	
	var shot_positions: Array = $ShotgunPositionFrontRight.get_children()
	shot_positions.append_array($ShotgunPositionBackRight.get_children())
	for n in shot_positions:
		var new_bullet: Area = Bullet.instance()
		n.add_child(new_bullet)
		new_bullet.damage = shotgun_damage
		new_bullet.reward = shotgun_reward
		new_bullet.burn = shotgun_burn
		new_bullet.shooter = self
		new_bullet.deletion_manager = deletion_manager
	
	if gles3:
		$MuzzleFlashShotgunFrontRight.emitting = true
		$MuzzleFlashShotgunBackRight.emitting = true
	else:
		$CPUMuzzleFlashShotgunFrontRight.emitting = true
		$CPUMuzzleFlashShotgunBackRight.emitting = true


func split(var b: bool):
	together = not b
	master_body = not b
	$BodyMesh.visible = not b
	$BodyMesh2.visible = not b
	$WheelFrontLeft.visible = not b
	$WheelFrontRight.visible = not b
	$WheelBackLeft.visible = not b
	$WheelBackRight.visible = not b
	$WheelFrontLeft2.visible = not b
	$WheelFrontRight2.visible = not b
	$WheelBackLeft2.visible = not b
	$WheelBackRight2.visible = not b
	$RocketParticles.visible = not b
	$RocketCPUParticles.visible = not b
	$ReverseRocketParticles.visible = not b
	$ReverseRocketCPUParticles.visible = not b
	front_half.visible = b
	back_half.visible = b
	if b:
		var body: AmmoVehicle = front_half.get_child(0)
		body.linear_velocity = linear_velocity
		body.angular_velocity = angular_velocity
		body.engine_force = engine_force
		body.health = health / 2
		body.ammo = ammo
		body.collision_layer = 1
		body.collision_mask = 3
		body.alive = true
		body.replacement = null
		body.global_transform = global_transform
		
		body.global_transform.origin += transform.basis.z * 2.5
		body.score = score
		body.master_body = true
		body.steering = steering
		replacement = body
		var camera: Spatial = $CameraBase
		remove_child(camera)
		body.add_child(camera)
		camera.get_node("Camera").global_transform.origin \
				= camera.get_node("InterpolationTarget").global_transform.origin
		camera.get_node(\
				"Camera/AspectRatioContainer/Control/ResourcesBackground/HealthBar"\
				).anchor_bottom = 0.65
		camera.get_node(\
				"Camera/AspectRatioContainer/Control/ResourcesBackground/HealthBar2"\
				).show()
		camera.get_node(\
				"Camera/AspectRatioContainer/Control/ResourcesBackground/HealthBar2"\
				).anchor_top = 0.7
		camera.get_node(\
				"Camera/AspectRatioContainer/Control/ResourcesBackground/HealthBar2"\
				).anchor_bottom = 0.8
		var array_position: int = gameplay_manager.players.find(self)
		gameplay_manager.players.remove(array_position)
		gameplay_manager.players.insert(array_position, body)
		array_position = gameplay_manager.pursuers.find(self)
		gameplay_manager.pursuers.remove(array_position)
		gameplay_manager.pursuers.insert(array_position, body)
		
		body = back_half.get_child(0)
		body.linear_velocity = linear_velocity
		body.angular_velocity = angular_velocity
		body.engine_force = engine_force
		body.health = health / 2
		body.collision_layer = 1
		body.collision_mask = 3
		body.alive = true
		body.replacement = null
		body.global_transform = global_transform
		
		body.global_transform.origin -= transform.basis.z * 2.5
		body.can_shoot = false
		back_half.get_node("MissileTimer").start()
		body.score = 0
		collision_layer = 0
		collision_mask = 0
	else:
		var body: AmmoVehicle = front_half.get_child(0)
		body.collision_layer = 0
		body.collision_mask = 0
		body.alive = false
		body.replacement = self
		if gles3:
			body.get_node("DeathParticles").restart()
			body.get_node("DeathParticles").emitting = false
		else:
			body.get_node("DeathCPUParticles").restart()
			body.get_node("DeathCPUParticles").emitting = false

		if not body.master_body:
			body = back_half.get_child(0)
		body.master_body = false
		score = body.score
		var camera: Spatial = body.get_node("CameraBase")
		body.remove_child(camera)
		add_child(camera)
		camera.get_node(\
				"Camera/AspectRatioContainer/Control/ResourcesBackground/HealthBar"\
				).anchor_top = 0.55
		camera.get_node(\
				"Camera/AspectRatioContainer/Control/ResourcesBackground/HealthBar"\
				).anchor_bottom = 0.8
		camera.get_node(\
				"Camera/AspectRatioContainer/Control/ResourcesBackground/HealthBar2"\
				).hide()
		var array_position: int = gameplay_manager.players.find(body)
		gameplay_manager.players.remove(array_position)
		gameplay_manager.players.insert(array_position, self)
		array_position = gameplay_manager.pursuers.find(body)
		gameplay_manager.pursuers.remove(array_position)
		gameplay_manager.pursuers.insert(array_position, self)
		
		body = back_half.get_child(0)
		body.collision_layer = 0
		body.collision_mask = 0
		body.alive = false
		body.replacement = self
		if gles3:
			body.get_node("DeathParticles").restart()
			body.get_node("DeathParticles").emitting = false
		else:
			body.get_node("DeathCPUParticles").restart()
			body.get_node("DeathCPUParticles").emitting = false
		
		score += body.score
		health = clamp(front_half.get_child(0).health, 0, 1000) \
				+ clamp(body.health, 0, 1000) 
		ammo = front_half.get_child(0).ammo
		collision_layer = 1
		collision_mask = 3
		replacement = null


func damage(amount: float, _reward: int, _burn: float, shooter: VehicleBody) \
		-> int:
	if alive and shooter != front_half.get_child(0) \
			and shooter != back_half.get_child(0):
		health -= amount
		if health <= 0:
			if shooter == null:
				health = 0
			else:
				alive = false
				get_node("../RespawnTimer").start()
				apply_central_impulse(transform.basis.y * 900)
				get_node("../AnimationPlayer").play("death")
				var payout: int = score / 5
				score -= payout
				if gles3:
					$DeathParticles.emitting = true
				else:
					$DeathCPUParticles.emitting = true
				return payout
		if controls == null:
			get_node("../StuckTimer").start()
	return 0


func _on_MachineGunTimer_timeout():
	can_shoot_lmg = true


func _on_ShotgunTimerLeft_timeout():
	can_shoot_shotgun_left = true


func _on_ShotgunTimerRight_timeout():
	can_shoot_shotgun_right = true
