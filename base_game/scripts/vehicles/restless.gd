extends AmmoVehicle


const Bullet: PackedScene \
		= preload("res://scenes/weapon_components/bullet.tscn")
const Sniper_Bullet: PackedScene \
		= preload("res://scenes/weapon_components/sniper_bullet.tscn")
const CartridgeCase: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_case.tscn")
const CartridgeLink: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_link.tscn")
const ShotSoundShotgun: PackedScene \
		= preload("res://scenes/weapon_components/shot_sound_shotgun.tscn")
const ShotSoundSniper: PackedScene \
		= preload("res://scenes/weapon_components/shot_sound_sniper.tscn")
const ShotSoundLMG: PackedScene \
		= preload("res://scenes/weapon_components/shot_sound_lmg.tscn")

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
	if controls == null:
		driver_name = "Restless"
	boost_type = boost_types.NITRO


func _physics_process(_delta):
	if sniper_case_out:
		var new_case: RigidBody = CartridgeCase.instance()
		$CartridgeExitSniper.add_child(new_case)
		new_case.set_as_toplevel(true)
		new_case.apply_central_impulse(new_case.transform.basis.x / 100)
		deletion_manager.other_rigid_bodies.append(new_case)
		
		sniper_case_out = false
	
	match next_out:
		cartridge_out.LINK:
			var new_link: RigidBody = CartridgeLink.instance()
			$CartridgeExitMachineGun.add_child(new_link)
			new_link.set_as_toplevel(true)
			new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 \
					- 10) / 10000, (new_link.transform.basis.x \
					+ new_link.transform.basis.y / 2) / 150)
			deletion_manager.other_rigid_bodies.append(new_link)
			
			next_out = cartridge_out.CASE
		cartridge_out.CASE:
			var new_case: RigidBody = CartridgeCase.instance()
			$CartridgeExitMachineGun.add_child(new_case)
			new_case.set_as_toplevel(true)
			new_case.apply_central_impulse(new_case.transform.basis.x / 100)
			deletion_manager.other_rigid_bodies.append(new_case)
			
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
					and collider_up.score >= 100) \
					or (collider_down != null \
					and collider_down.is_in_group("combat_vehicle") \
					and collider_down.score >= 100) \
					or (collider_left != null \
					and collider_left.is_in_group("combat_vehicle") \
					and collider_left.score >= 100) \
					or (collider_middle != null \
					and collider_middle.is_in_group("combat_vehicle") \
					and collider_middle.score >= 100) \
					or (collider_right != null \
					and collider_right.is_in_group("combat_vehicle") \
					and collider_right.score >= 100)):
				shoot_shotgun()
				get_node("../StuckTimer").start()
			
			collider_middle = $ShotPositionSniper.get_collider()
			if can_shoot_sniper and ammo >= sniper_ammo_cost and \
					collider_middle != null \
					and collider_middle.is_in_group("combat_vehicle") \
					and collider_middle.score >= 100:
				shoot_sniper()
				get_node("../StuckTimer").start()
			
			collider_middle = $ShotPositionMachineGun.get_collider()
			if can_shoot_lmg and ammo >= lmg_ammo_cost \
					and collider_middle != null \
					and collider_middle.is_in_group("combat_vehicle") \
					and collider_middle.score >= 100:
				shoot_lmg(true)
				get_node("../StuckTimer").start()
			elif get_node("../MachineGunTimer").is_stopped():
				shoot_lmg(false)
		else:
			if can_shoot_shotgun and ammo >= shotgun_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				shoot_shotgun()
			if can_shoot_sniper and ammo >= sniper_ammo_cost \
					and Input.is_action_pressed(controls.weapon_left):
				shoot_sniper()
			if can_shoot_lmg and ammo >= lmg_ammo_cost \
					and Input.is_action_pressed(controls.weapon_right):
				shoot_lmg(true)
			elif get_node("../MachineGunTimer").is_stopped():
				shoot_lmg(false)
			if Input.is_action_just_pressed(controls.weapon_back):
				if boost_type == boost_types.NITRO:
					boost_type = boost_types.ROCKET
					get_node("../AnimationPlayer").play("nitro_rocket")
					$OpenAudio.play()
					$LoopingAudio/NitroAudio.stream_paused = true
					if gles3:
						for n in $NitroParticles.get_children():
							n.emitting = false
					else:
						for n in $NitroCPUParticles.get_children():
							n.emitting = false
				else:
					boost_type = boost_types.NITRO
					get_node("../AnimationPlayer").play("rocket_nitro")
					$CloseAudio.play()
					$LoopingAudio/RocketAudio.stream_paused = true
					$LoopingAudio/ReverseRocketAudio.stream_paused = true
					if gles3:
						for n in $RocketParticles.get_children():
							n.emitting = false
						for n in $ReverseRocketParticles.get_children():
							n.emitting = false
					else:
						for n in $RocketCPUParticles.get_children():
							n.emitting = false
						for n in $ReverseRocketCPUParticles.get_children():
							n.emitting = false
	else:
		shoot_lmg(false)



func shoot_shotgun():
	ammo -= shotgun_ammo_cost
	can_shoot_shotgun = false
	get_node("../ShotgunTimer").start()
	
	apply_central_impulse(transform.basis.z * -shotgun_blast)
	
	var new_bullet: Area = Bullet.instance()
	$ShotPositionShotgunUp.add_child(new_bullet)
	new_bullet.damage = shotgun_damage
	new_bullet.reward = shotgun_reward
	new_bullet.burn = shotgun_burn
	new_bullet.shooter = self
	new_bullet.deletion_manager = deletion_manager
	
	new_bullet = Bullet.instance()
	$ShotPositionShotgunDown.add_child(new_bullet)
	new_bullet.damage = shotgun_damage
	new_bullet.reward = shotgun_reward
	new_bullet.burn = shotgun_burn
	new_bullet.shooter = self
	new_bullet.deletion_manager = deletion_manager
	
	new_bullet = Bullet.instance()
	$ShotPositionShotgunLeft.add_child(new_bullet)
	new_bullet.damage = shotgun_damage
	new_bullet.reward = shotgun_reward
	new_bullet.burn = shotgun_burn
	new_bullet.shooter = self
	new_bullet.deletion_manager = deletion_manager
	
	new_bullet = Bullet.instance()
	$ShotPositionShotgunMiddle.add_child(new_bullet)
	new_bullet.damage = shotgun_damage
	new_bullet.reward = shotgun_reward
	new_bullet.burn = shotgun_burn
	new_bullet.shooter = self
	new_bullet.deletion_manager = deletion_manager
	
	new_bullet = Bullet.instance()
	$ShotPositionShotgunRight.add_child(new_bullet)
	new_bullet.damage = shotgun_damage
	new_bullet.reward = shotgun_reward
	new_bullet.burn = shotgun_burn
	new_bullet.shooter = self
	new_bullet.deletion_manager = deletion_manager
	
	var new_sound: AudioStreamPlayer3D = ShotSoundShotgun.instance()
	$ShotPositionShotgunMiddle.add_child(new_sound)
	new_sound.deletion_manager = deletion_manager
	
	if gles3:
		$MuzzleFlashShotgun.emitting = true
	else:
		$CPUMuzzleFlashShotgun.emitting = true


func shoot_sniper():
	ammo -= sniper_ammo_cost
	can_shoot_sniper = false
	get_node("../SniperTimer").start()
	
	var new_bullet: Area = Sniper_Bullet.instance()
	$ShotPositionSniper.add_child(new_bullet)
	new_bullet.damage = sniper_damage
	new_bullet.reward = sniper_reward
	new_bullet.burn = sniper_burn
	new_bullet.shooter = self
	new_bullet.deletion_manager = deletion_manager
	
	var new_sound: AudioStreamPlayer3D = ShotSoundSniper.instance()
	$ShotPositionSniper.add_child(new_sound)
	new_sound.deletion_manager = deletion_manager
	
	sniper_case_out = true
	
	if gles3:
		$MuzzleFlashSniper.emitting = true
	else:
		$CPUMuzzleFlashSniper.emitting = true


func shoot_lmg(var b: bool):
	if b:
		ammo -= lmg_ammo_cost
		can_shoot_lmg = false
		get_node("../MachineGunTimer").start()
		next_out = cartridge_out.LINK
		
		var new_bullet: Area = Bullet.instance()
		$ShotPositionMachineGun.add_child(new_bullet)
		new_bullet.damage = lmg_damage
		new_bullet.reward = lmg_reward
		new_bullet.burn = lmg_burn
		new_bullet.shooter = self
		new_bullet.deletion_manager = deletion_manager
		
		var new_sound: AudioStreamPlayer3D = ShotSoundLMG.instance()
		$ShotPositionMachineGun.add_child(new_sound)
		new_sound.deletion_manager = deletion_manager
		
		if gles3:
			$MuzzleFlashMachineGun.emitting = true
		else:
			$CPUMuzzleFlashMachineGun.emitting = true
	else:
		if gles3:
			$MuzzleFlashMachineGun.emitting = false
		else:
			$CPUMuzzleFlashMachineGun.emitting = false


func _on_ShotgunTimer_timeout():
	can_shoot_shotgun = true


func _on_SniperTimer_timeout():
	can_shoot_sniper = true


func _on_MachineGunTimer_timeout():
	can_shoot_lmg = true
