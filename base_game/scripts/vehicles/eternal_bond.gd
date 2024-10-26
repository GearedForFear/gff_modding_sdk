extends AmmoVehicle


enum cartridge_out {NONE, LINK, CASE}

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
var next_out: int = cartridge_out.NONE

onready var front_half: Spatial \
		= preload("res://scenes/vehicles/eternal_bond_front.tscn").instance()
onready var back_half: Spatial \
		= preload("res://scenes/vehicles/eternal_bond_back.tscn").instance()


func _ready():
	if controls == null:
		driver_name = "Eternal Bond"
	
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
	$CameraBase/Camera/AspectRatioContainer/Control/Resources/HealthBarTop\
			.max_value = base_health / 2
	$CameraBase/Camera/AspectRatioContainer/Control/Resources/HealthBarBottom\
			.max_value = base_health / 2
	
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		delete($MuzzleFlashMG/CPULeft)
		delete($MuzzleFlashMG/CPURight)
		delete($MuzzleFlashLeft/CPUFront)
		delete($MuzzleFlashLeft/CPUBack)
		delete($MuzzleFlashRight/CPUFront)
		delete($MuzzleFlashRight/CPUBack)
	else:
		delete($MuzzleFlashMG/Left)
		delete($MuzzleFlashMG/Right)
		delete($MuzzleFlashLeft/Front)
		delete($MuzzleFlashLeft/Back)
		delete($MuzzleFlashRight/Front)
		delete($MuzzleFlashRight/Back)


func _physics_process(_delta):
	match next_out:
		cartridge_out.LINK:
			var new_link: DynamicShadowBody = pools.get_cartridge_link()
			new_link.start($CartridgeExitLeft.global_transform)
			new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 \
					- 10) / 10000, (new_link.transform.basis.x \
					+ new_link.transform.basis.y / 2) / 150)
			new_link = pools.get_cartridge_link()
			new_link.start($CartridgeExitRight.global_transform)
			new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 \
					- 10) / 10000, (new_link.transform.basis.x \
					+ new_link.transform.basis.y / 2) / 150)
			
			next_out = cartridge_out.CASE
		cartridge_out.CASE:
			var new_case: DynamicShadowBody = pools.get_cartridge_case()
			new_case.start($CartridgeExitLeft.global_transform)
			new_case.apply_central_impulse(new_case.transform.basis.x / 100)
			new_case = pools.get_cartridge_case()
			new_case.start($CartridgeExitRight.global_transform)
			new_case.apply_central_impulse(new_case.transform.basis.x / 100)
			
			next_out = cartridge_out.NONE
	
	if alive:
		if controls == null:
			var left_collider: PhysicsBody = $ShotPositionLeft.get_collider()
			var right_collider: PhysicsBody = $ShotPositionRight.get_collider()
			if can_shoot_lmg and ammo >= bullet_ammo_cost and ((left_collider \
					!= null and left_collider.is_in_group("combat_vehicle") \
					and left_collider.score >= 100) or (right_collider != null \
					and right_collider.is_in_group("combat_vehicle") \
					and right_collider.score >= 100)):
				shoot_front()
				get_node("../StuckTimer").start()
		else:
			if can_shoot_lmg and ammo >= bullet_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				shoot_front()
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


func shoot_front():
	ammo -= bullet_ammo_cost
	can_shoot_lmg = false
	get_node("../MachineGunTimer").start()
	next_out = cartridge_out.LINK
	
	var new_bullet: Area = pools.get_bullet()
	new_bullet.start($ShotPositionLeft.global_transform, bullet_damage, \
			bullet_reward, bullet_burn, self)
	new_bullet.play_audio_lmg()
	
	new_bullet = pools.get_bullet()
	new_bullet.start($ShotPositionRight.global_transform, bullet_damage, \
			bullet_reward, bullet_burn, self)
	new_bullet.play_audio_lmg()
	
	for n in $MuzzleFlashMG.get_children():
		n.restart()
		n.emitting = true


func shoot_left():
	ammo -= shotgun_ammo_cost
	can_shoot_shotgun_left = false
	get_node("../ShotgunTimerLeft").start()
	
	apply_impulse(transform.basis.z * 2.5, transform.basis.x * -shotgun_blast)
	
	var shot_positions: Array = $ShotgunPositionFrontLeft.get_children()
	shot_positions.append_array($ShotgunPositionBackLeft.get_children())
	for n in shot_positions:
		var new_bullet: Area = pools.get_bullet()
		new_bullet.start(n.global_transform, shotgun_damage, \
				shotgun_reward, shotgun_burn, self)
		n.add_child(new_bullet)
		if n.name == "ShotPositionMiddle":
			new_bullet.play_audio_shotgun()
	
	for n in $MuzzleFlashLeft.get_children():
		n.restart()
		n.emitting = true


func shoot_right():
	ammo -= shotgun_ammo_cost
	can_shoot_shotgun_right = false
	get_node("../ShotgunTimerRight").start()
	
	apply_impulse(transform.basis.z * 2.5, transform.basis.x * shotgun_blast)
	
	var shot_positions: Array = $ShotgunPositionFrontRight.get_children()
	shot_positions.append_array($ShotgunPositionBackRight.get_children())
	for n in shot_positions:
		var new_bullet: Area = pools.get_bullet()
		new_bullet.start(n.global_transform, shotgun_damage, \
				shotgun_reward, shotgun_burn, self)
		n.add_child(new_bullet)
		if n.name == "ShotPositionMiddle":
			new_bullet.play_audio_shotgun()
	
	for n in $MuzzleFlashRight.get_children():
		n.restart()
		n.emitting = true


func split(var b: bool):
	together = not b
	master_body = not b
	$BodyMesh.visible = not b
	$ScoreLabel.visible = not b
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
	get_viewport().stop()
	
	if b:
		var body: AmmoVehicle = front_half.get_child(0)
		body.linear_velocity = linear_velocity
		body.angular_velocity = angular_velocity
		body.engine_force = engine_force
		body.health = health / 2
		body.acid_duration = acid_duration / 2
		body.acid_cause = acid_cause
		body.ammo = ammo
		body.collision_layer = 1
		body.collision_mask = 3
		body.alive = true
		body.replacement = null
		body.global_transform = global_transform
		
		body.global_translation += transform.basis.z * 2.5
		body.score = score
		body.master_body = true
		body.steering = steering
		replacement = body
		body.get_node("SplitAudio").play()
		var camera: Spatial = $CameraBase
		remove_child(camera)
		body.add_child(camera)
		camera.get_node("Camera").global_translation \
				= camera.get_node("InterpolationTarget").global_translation
		camera.get_node(\
				"Camera/AspectRatioContainer/Control/Resources/HealthBar"\
				).hide()
		camera.get_node(\
				"Camera/AspectRatioContainer/Control/Resources/HealthBarTop"\
				).show()
		camera.get_node(\
				"Camera/AspectRatioContainer/Control/Resources/HealthBarBottom"\
				).show()
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
		body.acid_duration = acid_duration / 2
		body.acid_cause = acid_cause
		body.collision_layer = 1
		body.collision_mask = 3
		body.alive = true
		body.replacement = null
		body.global_transform = global_transform
		
		body.global_translation -= transform.basis.z * 2.5
		body.can_shoot = false
		back_half.get_node("MissileTimer").start()
		body.score = score
		collision_layer = 0
		collision_mask = 0
		acid_duration = 0
		acid_cause = null
	else:
		var body: AmmoVehicle = front_half.get_child(0)
		body.collision_layer = 0
		body.collision_mask = 0
		body.alive = false
		body.replacement = self
		acid_duration = body.acid_duration
		acid_cause = body.acid_cause
		body.acid_duration = 0
		body.acid_cause = null
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
				"Camera/AspectRatioContainer/Control/Resources/HealthBar"\
				).show()
		camera.get_node(\
				"Camera/AspectRatioContainer/Control/Resources/HealthBarTop"\
				).hide()
		camera.get_node(\
				"Camera/AspectRatioContainer/Control/Resources/HealthBarBottom"\
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
		acid_duration += body.acid_duration
		if acid_cause == null:
			acid_cause = body.acid_cause
		body.acid_duration = 0
		body.acid_cause = null
		if gles3:
			body.get_node("DeathParticles").restart()
			body.get_node("DeathParticles").emitting = false
		else:
			body.get_node("DeathCPUParticles").restart()
			body.get_node("DeathCPUParticles").emitting = false
		
		health = clamp(front_half.get_child(0).health, 0, 1000) \
				+ clamp(body.health, 0, 1000) 
		ammo = body.ammo
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
				var payout: int = score / 5
				score -= payout
				acid_duration = 0
				acid_cause = null
				if gles3:
					$ExplosionParticles.emitting = true
					$DeathParticles.emitting = true
				else:
					$ExplosionCPUParticles.emitting = true
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
