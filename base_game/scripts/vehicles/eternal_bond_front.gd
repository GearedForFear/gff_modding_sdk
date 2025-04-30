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

var can_shoot: bool = true
var other_half: AmmoVehicle
var can_shoot_shotgun_left: bool = true
var can_shoot_shotgun_right: bool = true
var next_out: int = cartridge_out.NONE


func _ready():
	target = get_node("../..").target
	set_as_toplevel(true)
	
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
			if can_shoot and ammo >= bullet_ammo_cost and ((left_collider \
					!= null and left_collider.is_in_group("combat_vehicle") \
					and left_collider.scoreboard_record.score >= 100) or (right_collider != null \
					and right_collider.is_in_group("combat_vehicle") \
					and right_collider.scoreboard_record.score >= 100)):
				shoot_front()
				get_node("../StuckTimer").start()
		else:
			if can_shoot and ammo >= bullet_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				shoot_front()
			if can_shoot_shotgun_left and ammo >= shotgun_ammo_cost \
					and Input.is_action_pressed(controls.weapon_left):
				shoot_left()
			if can_shoot_shotgun_right and ammo >= shotgun_ammo_cost \
					and Input.is_action_pressed(controls.weapon_right):
				shoot_right()
	
	if master_body:
		$CameraBase/Camera/AspectRatioContainer/Control/Resources/HealthBarTop\
			.value = health
		$CameraBase/Camera/AspectRatioContainer/Control/Resources/HealthBarBottom\
			.value = other_half.health


func shoot_front():
	ammo -= bullet_ammo_cost
	can_shoot = false
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
	
	apply_central_impulse(transform.basis.x * -shotgun_blast)
	
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
	
	apply_central_impulse(transform.basis.x * shotgun_blast)
	
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
				var payout: int = scoreboard_record.score / 10
				scoreboard_record.lose(payout)
				acid_duration = 0
				acid_cause = null
				if gles3:
					$ExplosionParticles.emitting = true
					$DeathParticles.emitting = true
				else:
					$ExplosionCPUParticles.emitting = true
					$DeathCPUParticles.emitting = true
				if other_half.alive:
					other_half.master_body = true
					master_body = false
					replacement = other_half
					get_viewport().stop()
					var camera: Spatial = $CameraBase
					remove_child(camera)
					other_half.add_child(camera)
					camera.get_node("Camera").global_transform.origin \
					= camera.get_node("InterpolationTarget")\
							.global_transform.origin
					var array_position: int \
							= gameplay_manager.pursuers.find(self)
					gameplay_manager.pursuers.remove(array_position)
					gameplay_manager.pursuers.insert(array_position, other_half)
				else:
					get_node("../..").alive = false
					get_node("../RespawnTimer").start()
				return payout
	return 0


func _on_MachineGunTimer_timeout():
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


func _on_ShotgunTimerLeft_timeout():
	can_shoot_shotgun_left = true


func _on_ShotgunTimerRight_timeout():
	can_shoot_shotgun_right = true
