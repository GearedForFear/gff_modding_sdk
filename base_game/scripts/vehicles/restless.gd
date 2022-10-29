extends AmmoVehicle


const Bullet: PackedScene \
		= preload("res://scenes/weapon_components/bullet.tscn")
const Sniper_Bullet: PackedScene \
		= preload("res://scenes/weapon_components/sniper_bullet.tscn")
const CartridgeCase: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_case.tscn")
const CartridgeLink: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_link.tscn")

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

onready var shotgun_timer: Timer = get_node("../ShotgunTimer")
onready var sniper_timer: Timer = get_node("../SniperTimer")
onready var lmg_timer: Timer = get_node("../MachineGunTimer")


func _ready():
	if controls == null:
		driver_name = "Restless"
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
		$SniperMesh.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$MachineGunMesh.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$RocketMeshLeft.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$RocketMeshRight.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$DoorMesh.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
	boost_type = boost_types.NITRO


func _physics_process(_delta):
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
			elif lmg_timer.is_stopped():
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
			elif lmg_timer.is_stopped():
				shoot_lmg(false)
			if Input.is_action_just_pressed(controls.weapon_back):
				if boost_type == boost_types.NITRO:
					boost_type = boost_types.ROCKET
					get_node("../AnimationPlayer").play("nitro_rocket")
					if gles3:
						for n in $NitroParticles.get_children():
							n.emitting = false
					else:
						for n in $NitroCPUParticles.get_children():
							n.emitting = false
				else:
					boost_type = boost_types.NITRO
					get_node("../AnimationPlayer").play("rocket_nitro")
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
	shotgun_timer.start()
	
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
	
	if gles3:
		$MuzzleFlashShotgun.emitting = true
	else:
		$CPUMuzzleFlashShotgun.emitting = true


func shoot_sniper():
	ammo -= sniper_ammo_cost
	can_shoot_sniper = false
	sniper_timer.start()
	
	var new_bullet: Area = Sniper_Bullet.instance()
	$ShotPositionSniper.add_child(new_bullet)
	new_bullet.damage = sniper_damage
	new_bullet.reward = sniper_reward
	new_bullet.burn = sniper_burn
	new_bullet.shooter = self
	new_bullet.deletion_manager = deletion_manager
	
	var new_case: RigidBody = CartridgeCase.instance()
	$CartridgeExitSniper.add_child(new_case)
	new_case.set_as_toplevel(true)
	new_case.apply_central_impulse(new_case.transform.basis.x * 10)
	deletion_manager.other_rigid_bodies.append(new_case)
	
	if gles3:
		$MuzzleFlashSniper.emitting = true
	else:
		$CPUMuzzleFlashSniper.emitting = true


func shoot_lmg(var b: bool):
	if b:
		ammo -= lmg_ammo_cost
		can_shoot_lmg = false
		lmg_timer.start()
		
		var new_bullet: Area = Bullet.instance()
		$ShotPositionMachineGun.add_child(new_bullet)
		new_bullet.damage = lmg_damage
		new_bullet.reward = lmg_reward
		new_bullet.burn = lmg_burn
		new_bullet.shooter = self
		new_bullet.deletion_manager = deletion_manager
		
		var new_case: RigidBody = CartridgeCase.instance()
		$CartridgeExitMachineGun.add_child(new_case)
		new_case.set_as_toplevel(true)
		new_case.apply_central_impulse(new_case.transform.basis.x * 10)
		deletion_manager.other_rigid_bodies.append(new_case)
		
		var new_link: RigidBody = CartridgeLink.instance()
		$CartridgeExitMachineGun.add_child(new_link)
		new_link.set_as_toplevel(true)
		new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 - 10)\
				/ 10000, (new_case.transform.basis.x \
				+ new_link.transform.basis.y) * 4)
		deletion_manager.other_rigid_bodies.append(new_link)
		
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
