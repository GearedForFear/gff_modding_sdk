extends AmmoVehicle


enum cartridge_out {NONE, LINK, CASE}

export var sniper_damage: float = 40.0
export var sniper_reward: int = 18
export var sniper_burn: float = 4.0
export var sniper_ammo_cost: float = 25.0

export var lmg_damage: float = 4.0
export var lmg_reward: int = 1
export var lmg_burn: float = 0.4
export var lmg_ammo_cost: float = 4.0

var can_shoot_sniper: bool = true
var can_shoot_lmg: bool = true
var sniper_case_out: bool = false
var next_out: int = cartridge_out.NONE


func _ready():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		DeletionManager.add_array_to_garbage([$SniperFlash/CPUParticles,
				$MachineGunFlash/CPUParticles])
	else:
		DeletionManager.add_array_to_garbage([$SniperFlash/Particles,
				$MachineGunFlash/Particles])
	
	$BoostSwitch.second_boost.prepare(self)


func _physics_process(_delta):
	if sniper_case_out:
		var new_case: DynamicShadowBody = pools.get_cartridge_case()
		new_case.start($CartridgeExitSniper.global_transform)
		new_case.apply_central_impulse(new_case.transform.basis.x / 100)
		
		sniper_case_out = false
	
	match next_out:
		cartridge_out.LINK:
			var new_link: DynamicShadowBody = pools.get_cartridge_link()
			new_link.start($CartridgeExitMachineGun.global_transform)
			new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 \
					- 10) / 10000, (new_link.transform.basis.x \
					+ new_link.transform.basis.y / 2) / 150)
			
			next_out = cartridge_out.CASE
		cartridge_out.CASE:
			var new_case: DynamicShadowBody = pools.get_cartridge_case()
			new_case.start($CartridgeExitMachineGun.global_transform)
			new_case.apply_central_impulse(new_case.transform.basis.x / 100)
			
			next_out = cartridge_out.NONE
	
	if alive:
		if controls == null:
			var collider_middle: PhysicsBody \
					= $ShotPositionSniper.get_collider()
			if can_shoot_sniper and ammo >= sniper_ammo_cost and \
					collider_middle != null \
					and collider_middle.is_in_group("combat_vehicle") \
					and collider_middle.scoreboard_record.score >= 100:
				shoot_sniper()
				get_node("../StuckTimer").start()
			
			collider_middle = $ShotPositionMachineGun.get_collider()
			if can_shoot_lmg and ammo >= lmg_ammo_cost \
					and collider_middle != null \
					and collider_middle.is_in_group("combat_vehicle") \
					and collider_middle.scoreboard_record.score >= 100:
				shoot_lmg()
				get_node("../StuckTimer").start()
		else:
			var boost_switch: Spatial = $BoostSwitch
			if Input.is_action_just_pressed(controls.weapon_back):
				boost_switch.use(self)
			
			var enable_spoiler := false
			if boost == boost_switch.second_boost:
				if can_shoot_lmg and ammo >= lmg_ammo_cost \
						and Input.is_action_pressed(controls.weapon_front):
					shoot_lmg()
				
				if Input.is_action_pressed(controls.weapon_left):
					$Shield.absorb(self)
				else:
					$Shield.disable(self)
				
				if Input.is_action_pressed(controls.weapon_right):
					$Jump.use(self)
			else:
				if can_shoot_sniper and ammo >= sniper_ammo_cost \
						and Input.is_action_pressed(controls.weapon_front):
					shoot_sniper()
				
				if Input.is_action_pressed(controls.weapon_left):
					$Shield.deflect(self)
				else:
					$Shield.disable(self)
				
				if Input.is_action_pressed(controls.weapon_right):
					enable_spoiler = true
			
			$Spoiler.use(self, enable_spoiler)


func shoot_sniper():
	ammo -= sniper_ammo_cost
	can_shoot_sniper = false
	get_node("../SniperTimer").start()
	
	var new_bullet: Area = pools.get_sniper_bullet()
	new_bullet.start($ShotPositionSniper.global_transform, sniper_damage, \
			sniper_reward, sniper_burn, self)
	new_bullet.play_audio_sniper()
	
	sniper_case_out = true
	
	$SniperFlash.get_child(0).emitting = true


func shoot_lmg():
	ammo -= lmg_ammo_cost
	can_shoot_lmg = false
	get_node("../MachineGunTimer").start()
	next_out = cartridge_out.LINK
	
	var new_bullet: Area = pools.get_bullet()
	new_bullet.start($ShotPositionMachineGun.global_transform, lmg_damage, \
			lmg_reward, lmg_burn, self)
	new_bullet.play_audio_lmg()
	
	var flash: GeometryInstance = $MachineGunFlash.get_child(0)
	flash.restart()
	flash.emitting = true


func _on_SniperTimer_timeout():
	can_shoot_sniper = true


func _on_MachineGunTimer_timeout():
	can_shoot_lmg = true
