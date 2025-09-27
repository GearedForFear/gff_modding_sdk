extends HeatVehicle


enum cartridge_out {NONE, LINK, CASE}

export var bullet_damage: float = 3.6
export var bullet_reward: int = 2
export var bullet_burn: float = 0.3
export var bullet_heat_cost_normal: float = 1.0
export var bullet_heat_cost_ricochet: float = 0.1

export var flamethrower_damage: float = 1.2
export var flamethrower_reward: int = 1
export var flamethrower_burn: float = 1.0
export var flamethrower_push: int = 300
export var flamethrower_heat_cost: float = 0.12

var can_shoot_left: bool = true
var can_shoot_right: bool = true
var next_out_left: int = cartridge_out.NONE
var next_out_right: int = cartridge_out.NONE


func _ready():
	if controls != null:
		random_skin("res://resources/materials/vehicles/no_match/", "")
	get_node("../AnimationPlayerHeat").play("RESET")
	
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		delete($MuzzleFlashLeftCPU)
		delete($MuzzleFlashRightCPU)
	else:
		delete($MuzzleFlashLeft)
		delete($MuzzleFlashRight)
		$MuzzleFlashLeftCPU.name = "MuzzleFlashLeft"
		$MuzzleFlashRightCPU.name = "MuzzleFlashRight"


func _physics_process(_delta):
	match next_out_left:
		cartridge_out.LINK:
			var new_link: DynamicShadowBody = pools.get_cartridge_link()
			new_link.start($CartridgeExitLeft.global_transform)
			new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 \
					- 10) / 10000, (new_link.transform.basis.x \
					+ new_link.transform.basis.y / 2) / 150)
			
			next_out_left = cartridge_out.CASE
		cartridge_out.CASE:
			var new_case: DynamicShadowBody = pools.get_cartridge_case()
			new_case.start($CartridgeExitLeft.global_transform)
			new_case.apply_central_impulse(new_case.transform.basis.x / 100)
			
			next_out_left = cartridge_out.NONE
	match next_out_right:
		cartridge_out.LINK:
			var new_link: DynamicShadowBody = pools.get_cartridge_link()
			new_link.start($CartridgeExitRight.global_transform)
			new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 \
					- 10) / 10000, (new_link.transform.basis.x \
					+ new_link.transform.basis.y / 2) / 150)
			
			next_out_right = cartridge_out.CASE
		cartridge_out.CASE:
			var new_case: DynamicShadowBody = pools.get_cartridge_case()
			new_case.start($CartridgeExitRight.global_transform)
			new_case.apply_central_impulse(new_case.transform.basis.x / 100)
			
			next_out_right = cartridge_out.NONE
	
	if alive:
		if controls == null:
			var left_collider: PhysicsBody = $ShotPositionLeft.get_collider()
			var right_collider: PhysicsBody = $ShotPositionRight.get_collider()
			if can_shoot_left and heat < 24.0 and left_collider != null \
					and left_collider.is_in_group("combat_vehicle") \
					and left_collider.scoreboard_record.score >= 100:
				shoot(true, false)
				get_node("../StuckTimer").start()
			elif get_node("../GunTimerLeft").is_stopped():
				shoot(false, false)
			else:
				delay_overheat = true
			if can_shoot_right and heat < 24.7 and right_collider != null \
					and right_collider.is_in_group("combat_vehicle") \
					and right_collider.scoreboard_record.score >= 100:
				shoot(true, true)
				get_node("../StuckTimer").start()
			elif get_node("../GunTimerRight").is_stopped():
				shoot(false, true)
			else:
				delay_overheat = true
		else:
			if can_shoot_left \
					and Input.is_action_pressed(controls.weapon_front):
				shoot(true, false)
			elif get_node("../GunTimerLeft").is_stopped():
				shoot(false, false)
			else:
				delay_overheat = true
			
			if can_shoot_right \
					and Input.is_action_pressed(controls.weapon_back):
				shoot(true, true)
			elif get_node("../GunTimerRight").is_stopped():
				shoot(false, true)
			else:
				delay_overheat = true
			
			if Input.is_action_pressed(controls.weapon_left):
				flame_left(true)
			else:
				flame_left(false)
			
			if Input.is_action_pressed(controls.weapon_right):
				flame_right(true)
			else:
				flame_right(false)
	else:
		shoot(false, false)
		shoot(false, true)
		flame_left(false)
		flame_right(false)


func shoot(var trigger: bool, var ricochet: bool):
	if trigger:
		if ricochet:
			get_node("../AnimationPlayerRight").play("rotation")
			get_node("../AnimationPlayerRight").seek(0.0, false)
			change_heat(bullet_heat_cost_ricochet)
			can_shoot_right = false
			get_node("../GunTimerRight").start()
			$LoopingAudio/GunRotationAudioRight.stream_paused = false
			next_out_right = cartridge_out.LINK
			
			var new_bullet: Area = pools.get_ricochet_bullet()
			new_bullet.start($ShotPositionRight.global_transform, bullet_damage,\
					bullet_reward, bullet_burn, self)
			new_bullet.play_audio_lmg()
			
			var flash: GeometryInstance = $MuzzleFlashRight
			flash.restart()
			flash.emitting = true
		else:
			get_node("../AnimationPlayerLeft").play("rotation")
			get_node("../AnimationPlayerLeft").seek(0.0, false)
			change_heat(bullet_heat_cost_normal)
			can_shoot_left = false
			get_node("../GunTimerLeft").start()
			$LoopingAudio/GunRotationAudioLeft.stream_paused = false
			next_out_left = cartridge_out.LINK
			
			var new_bullet: Area = pools.get_bullet()
			new_bullet.start($ShotPositionLeft.global_transform, bullet_damage, \
					bullet_reward, bullet_burn, self)
			new_bullet.play_audio_lmg()
			
			var flash: GeometryInstance = $MuzzleFlashLeft
			flash.restart()
			flash.emitting = true
	else:
		if ricochet:
			$LoopingAudio/GunRotationAudioRight.stream_paused = true
		else:
			$LoopingAudio/GunRotationAudioLeft.stream_paused = true


func flame_left(var b: bool):
	if b:
		apply_central_impulse(transform.basis.x * -flamethrower_push)
		change_heat(flamethrower_heat_cost)
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
		change_heat(flamethrower_heat_cost)
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


func get_vehicle_name() -> String:
	return "No Match"


func _on_GunTimerLeft_timeout():
	can_shoot_left = true


func _on_GunTimerRight_timeout():
	can_shoot_right = true
