extends AmmoVehicle


enum cartridge_out {NONE, LINK, CASE}

export var shotgun_damage: float = 6.0
export var shotgun_reward: int = 1
export var shotgun_burn: float = 0.6
export var shotgun_ammo_cost: float = 6.0
export var shotgun_blast: float = 500.0

export var sniper_damage: float = 40.0
export var sniper_reward: int = 18
export var sniper_burn: float = 4.0
export var sniper_ammo_cost: float = 25.0

export var lmg_damage: float = 4.0
export var lmg_reward: int = 1
export var lmg_burn: float = 0.4
export var lmg_ammo_cost: float = 4.0

var can_shoot_shotgun: bool = true
var can_shoot_sniper: bool = true
var can_shoot_lmg: bool = true
var sniper_case_out: bool = false
var next_out: int = cartridge_out.NONE


func _ready():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		DeletionManager.add_to_stack($ShotgunFlash/CPUParticles)
		DeletionManager.add_to_stack($SniperFlash/CPUParticles)
		DeletionManager.add_to_stack($MachineGunFlash/CPUParticles)
	else:
		DeletionManager.add_to_stack($ShotgunFlash/Particles)
		DeletionManager.add_to_stack($SniperFlash/Particles)
		DeletionManager.add_to_stack($MachineGunFlash/Particles)
	
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
			var collider_up: PhysicsBody \
					= $ShotPositionShotgunMiddle.get_collider()
			var collider_down: PhysicsBody \
					= $ShotPositionShotgunMiddle.get_collider()
			var collider_left: PhysicsBody \
					= $ShotPositionShotgunMiddle.get_collider()
			var collider_middle: PhysicsBody \
					= $ShotPositionShotgunMiddle.get_collider()
			var collider_right: PhysicsBody \
					= $ShotPositionShotgunMiddle.get_collider()
			if can_shoot_shotgun and ammo >= shotgun_ammo_cost and \
					((collider_up != null \
					and collider_up.is_in_group("combat_vehicle") \
					and collider_up.scoreboard_record.score >= 100) \
					or (collider_down != null \
					and collider_down.is_in_group("combat_vehicle") \
					and collider_down.scoreboard_record.score >= 100) \
					or (collider_left != null \
					and collider_left.is_in_group("combat_vehicle") \
					and collider_left.scoreboard_record.score >= 100) \
					or (collider_middle != null \
					and collider_middle.is_in_group("combat_vehicle") \
					and collider_middle.scoreboard_record.score >= 100) \
					or (collider_right != null \
					and collider_right.is_in_group("combat_vehicle") \
					and collider_right.scoreboard_record.score >= 100)):
				shoot_shotgun()
				get_node("../StuckTimer").start()
			
			collider_middle = $ShotPositionSniper.get_collider()
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
			if can_shoot_shotgun and ammo >= shotgun_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				shoot_shotgun()
			if can_shoot_sniper and ammo >= sniper_ammo_cost \
					and Input.is_action_pressed(controls.weapon_left):
				shoot_sniper()
			if can_shoot_lmg and ammo >= lmg_ammo_cost \
					and Input.is_action_pressed(controls.weapon_right):
				shoot_lmg()
			if Input.is_action_just_pressed(controls.weapon_back):
				$BoostSwitch.use(self)



func shoot_shotgun():
	ammo -= shotgun_ammo_cost
	can_shoot_shotgun = false
	get_node("../ShotgunTimer").start()
	
	apply_central_impulse(transform.basis.z * -shotgun_blast)
	
	pools.get_bullet().start($ShotPositionShotgunUp.global_transform, \
			shotgun_damage, shotgun_reward, shotgun_burn, self)
	
	pools.get_bullet().start($ShotPositionShotgunDown.global_transform, \
			shotgun_damage, shotgun_reward, shotgun_burn, self)
	
	pools.get_bullet().start($ShotPositionShotgunLeft.global_transform, \
			shotgun_damage, shotgun_reward, shotgun_burn, self)
	
	var new_bullet: Area = pools.get_bullet()
	new_bullet.start($ShotPositionShotgunMiddle.global_transform, shotgun_damage, \
			shotgun_reward, shotgun_burn, self)
	new_bullet.play_audio_shotgun()
	
	pools.get_bullet().start($ShotPositionShotgunRight.global_transform, \
			shotgun_damage, shotgun_reward, shotgun_burn, self)
	
	$ShotgunFlash.get_child(0).emitting = true


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


func _on_ShotgunTimer_timeout():
	can_shoot_shotgun = true


func _on_SniperTimer_timeout():
	can_shoot_sniper = true


func _on_MachineGunTimer_timeout():
	can_shoot_lmg = true
