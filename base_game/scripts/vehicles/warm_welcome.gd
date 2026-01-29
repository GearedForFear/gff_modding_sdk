extends AmmoVehicle


enum cartridge_out {NONE, LINK, CASE}

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
var next_out: int = cartridge_out.NONE


func _ready():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		DeletionManager.add_to_stack($MuzzleFlash/CPULeft)
		DeletionManager.add_to_stack($MuzzleFlash/CPURight)
	else:
		DeletionManager.add_to_stack($MuzzleFlash/Left)
		DeletionManager.add_to_stack($MuzzleFlash/Right)


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
		$LoopingAudio/GunRotationAudio.stream_paused = false
		next_out = cartridge_out.LINK
		
		var new_bullet: Area = pools.get_bullet()
		new_bullet.start($ShotPositionLeft.global_transform, bullet_damage, \
				bullet_reward, bullet_burn, self)
		new_bullet.play_audio_lmg()
		
		new_bullet = pools.get_bullet()
		new_bullet.start($ShotPositionRight.global_transform, bullet_damage, \
				bullet_reward, bullet_burn, self)
		new_bullet.play_audio_lmg()
		
		for n in $MuzzleFlash.get_children():
			n.restart()
			n.emitting = true
	else:
		$LoopingAudio/GunRotationAudio.stream_paused = true


func jump():
	if $WheelFrontLeft.is_in_contact() or $WheelFrontRight.is_in_contact() or \
			$WheelBackLeft.is_in_contact() or $WheelBackRight.is_in_contact():
		apply_central_impulse(transform.basis.y * jump_force)
		if not $JumpAudio.playing or $JumpAudio.get_playback_position() > 0.3:
			$JumpAudio.play()


func flame_left(var b: bool):
	if b:
		apply_central_impulse(transform.basis.x * -flamethrower_push)
		ammo -= flamethrower_ammo_cost
		deal_flame_damage($FlameDamageFrontLeft)
		deal_flame_damage($FlameDamageBackLeft)
		$LoopingAudio/FlameAudioLeft.stream_paused = false
		
		if gles3:
			$FlamethrowerParticlesFrontLeft.emitting = true
			$FlamethrowerParticlesBackLeft.emitting = true
		else:
			$FlamethrowerCPUParticlesFrontLeft.emitting = true
			$FlamethrowerCPUParticlesBackLeft.emitting = true
	else:
		$LoopingAudio/FlameAudioLeft.stream_paused = true
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
		$LoopingAudio/FlameAudioRight.stream_paused = false
		
		if gles3:
			$FlamethrowerParticlesFrontRight.emitting = true
			$FlamethrowerParticlesBackRight.emitting = true
		else:
			$FlamethrowerCPUParticlesFrontRight.emitting = true
			$FlamethrowerCPUParticlesBackRight.emitting = true
	else:
		$LoopingAudio/FlameAudioRight.stream_paused = true
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
				var new_money: Area = pools.get_money()
				new_money.start(global_transform, self, n, payout)
				new_money.speed_divisor = 2.0


func _on_GunTimer_timeout():
	can_shoot = true
