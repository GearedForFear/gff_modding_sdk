extends LevelVehicle


const Bullet: PackedScene \
		= preload("res://scenes/weapon_components/bullet.tscn")
const AcidBullet: PackedScene \
		= preload("res://scenes/weapon_components/acid_bullet.tscn")
const CartridgeCase: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_case.tscn")
const CartridgeLink: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_link.tscn")
const ShotSoundLMG: PackedScene \
		= preload("res://scenes/weapon_components/shot_sound_lmg.tscn")
const ShotSoundShotgun: PackedScene \
		= preload("res://scenes/weapon_components/shot_sound_shotgun.tscn")

export var bullet_damage: float = 8.0
export var bullet_reward: int = 1
export var bullet_burn: float = 0.2
export var bullet_xp: float = 3.0
export var acid_bullet_damage: float = 6.0
export var acid_bullet_duration: int = 30

export var shotgun_damage: float = 6.0
export var shotgun_reward: int = 1
export var shotgun_burn: float = 0.2
export var shotgun_xp: float = 10.0
export var shotgun_acid_damage: float = 5.5
export var shotgun_acid_duration: int = 10
export var shotgun_blast: float = 900.0

var can_trigger: bool = true
var can_shoot_middle: bool = true
var can_shoot_sides: bool = true
var can_shoot_shotgun: bool = true
var remaining_shots_middle: int = 0
var remaining_shots_sides: int = 0


func _ready():
	if controls == null:
		driver_name = "Well Raised"
	if get_node("/root/RootControl/SettingsManager").shadow_casters <= 1:
		$BodyMesh.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontLeft/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontRight/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackLeft/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackRight/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$MGMeshLeft.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$MGMeshMiddle.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$MGMeshRight.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF


func _physics_process(_delta):
	if alive:
		if controls == null:
			var left_collider: PhysicsBody = $MGMeshLeft/ShotPosition.get_collider()
			var middle_collider: PhysicsBody = $MGMeshMiddle/ShotPosition.get_collider()
			var right_collider: PhysicsBody = $MGMeshRight/ShotPosition.get_collider()
			if can_trigger:
				if middle_collider != null and \
						middle_collider.is_in_group("combat_vehicle") \
						and middle_collider.score >= 100:
					remaining_shots_middle = get_shots()
					can_trigger = false
					get_node("../StuckTimer").start()
				elif (left_collider != null and \
						left_collider.is_in_group("combat_vehicle") \
						and left_collider.score >= 100) \
						or (right_collider != null and \
						right_collider.is_in_group("combat_vehicle") \
						and right_collider.score >= 100):
					remaining_shots_sides = get_shots()
					can_trigger = false
					get_node("../StuckTimer").start()
		
		else:
			if can_trigger:
				if Input.is_action_pressed(controls.weapon_front):
					remaining_shots_middle = get_shots()
					can_trigger = false
				elif Input.is_action_pressed(controls.weapon_back):
					remaining_shots_sides = get_shots()
					can_trigger = false
			
			if can_shoot_shotgun:
				if Input.is_action_pressed(controls.weapon_left):
					shoot_left()
				elif Input.is_action_pressed(controls.weapon_right):
					shoot_right()
		
		if remaining_shots_middle > 0 and can_shoot_middle:
			shoot_middle(true)
			shoot_sides(false)
		elif remaining_shots_sides > 0 and can_shoot_sides:
			shoot_middle(false)
			shoot_sides(true)
		elif get_node("../ShotTimerMiddle").is_stopped() \
				and get_node("../ShotTimerSides").is_stopped():
			shoot_middle(false)
			shoot_sides(false)
		else:
			get_node("../GunTriggerTimer").start()
	else:
		pass


func get_shots() -> int:
	match level:
		1:
			return 2
		2:
			return 3
		3:
			return 4
		_:
			return 5


func shoot_middle(var b: bool):
	if b:
		xp += bullet_xp
		can_shoot_middle = false
		get_node("../ShotTimerMiddle").start()
		remaining_shots_middle -= 1
	shoot_front(b, $MGMeshMiddle)


func shoot_sides(var b: bool):
	if b:
		xp += bullet_xp
		can_shoot_sides = false
		get_node("../ShotTimerSides").start()
		remaining_shots_sides -= 1
	shoot_front(b, $MGMeshLeft)
	shoot_front(b, $MGMeshRight)


func shoot_left():
	xp += shotgun_xp
	can_shoot_shotgun = false
	get_node("../ShotgunTimer").start()
	
	apply_central_impulse(transform.basis.x * -shotgun_blast * level)
	
	shoot_shotgun($ShotgunPositionFrontLeft)
	shoot_shotgun($ShotgunPositionBackLeft)
	
	if gles3:
		$MuzzleFlashShotgunFrontLeft.emitting = true
		$MuzzleFlashShotgunBackLeft.emitting = true
	else:
		$CPUMuzzleFlashShotgunFrontLeft.emitting = true
		$CPUMuzzleFlashShotgunBackLeft.emitting = true


func shoot_right():
	xp += shotgun_xp
	can_shoot_shotgun = false
	get_node("../ShotgunTimer").start()
	
	apply_central_impulse(transform.basis.x * shotgun_blast * level)
	
	shoot_shotgun($ShotgunPositionFrontRight)
	shoot_shotgun($ShotgunPositionBackRight)
	
	if gles3:
		$MuzzleFlashShotgunFrontRight.emitting = true
		$MuzzleFlashShotgunBackRight.emitting = true
	else:
		$CPUMuzzleFlashShotgunFrontRight.emitting = true
		$CPUMuzzleFlashShotgunBackRight.emitting = true


func shoot_front(var b: bool, var gun: MeshInstance):
	if b:
		var new_bullet: Area
		if level == 5:
			new_bullet = AcidBullet.instance()
			new_bullet.acid_duration = acid_bullet_duration
			new_bullet.damage = acid_bullet_damage
		else:
			new_bullet = Bullet.instance()
			new_bullet.damage = bullet_damage
		var new_sound: AudioStreamPlayer3D = ShotSoundLMG.instance()
		gun.get_node("ShotPosition").add_child(new_bullet)
		new_bullet.reward = bullet_reward
		new_bullet.burn = bullet_burn
		new_bullet.shooter = self
		new_bullet.deletion_manager = deletion_manager
		gun.get_node("ShotPosition").add_child(new_sound)
		new_sound.deletion_manager = deletion_manager
		
		var new_case: RigidBody = CartridgeCase.instance()
		gun.get_node("CartridgeExit").add_child(new_case)
		new_case.set_as_toplevel(true)
		new_case.apply_central_impulse(new_case.transform.basis.x * -0.006 \
				+ new_case.transform.basis.y * 0.004)
		deletion_manager.other_rigid_bodies.append(new_case)
		
		var new_link: RigidBody = CartridgeLink.instance()
		gun.get_node("CartridgeExit").add_child(new_link)
		new_link.set_as_toplevel(true)
		new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 - 10)\
				/ 10000, (new_link.transform.basis.x * -1 \
				+ new_link.transform.basis.y) * 0.004)
		deletion_manager.other_rigid_bodies.append(new_link)
		
		if gles3:
			gun.get_node("MuzzleFlash").emitting = true
		else:
			gun.get_node("CPUMuzzleFlash").emitting = true
	else:
		if gles3:
			gun.get_node("MuzzleFlash").emitting = false
		else:
			gun.get_node("CPUMuzzleFlash").emitting = false


func shoot_shotgun(var gun: Spatial):
	var shot_positions: Array = Array()
	match level:
		1:
			shot_positions.append(gun.get_node("ShotPositionLeft"))
			shot_positions.append(gun.get_node("ShotPositionRight"))
		2:
			shot_positions.append(gun.get_node("ShotPositionLeft"))
			shot_positions.append(gun.get_node("ShotPositionMiddle"))
			shot_positions.append(gun.get_node("ShotPositionRight"))
		3:
			shot_positions.append(gun.get_node("ShotPositionUp"))
			shot_positions.append(gun.get_node("ShotPositionLeft"))
			shot_positions.append(gun.get_node("ShotPositionMiddle"))
			shot_positions.append(gun.get_node("ShotPositionRight"))
			shot_positions.append(gun.get_node("ShotPositionDown"))
		_:
			shot_positions.append_array(gun.get_children())
	for n in shot_positions:
		var new_bullet: Area
		if level == 5:
			new_bullet = AcidBullet.instance()
		else:
			new_bullet = Bullet.instance()
		n.add_child(new_bullet)
		new_bullet.damage = shotgun_damage
		new_bullet.reward = shotgun_reward
		new_bullet.burn = shotgun_burn
		new_bullet.shooter = self
		new_bullet.deletion_manager = deletion_manager
	
	var new_sound: AudioStreamPlayer3D = ShotSoundShotgun.instance()
	gun.add_child(new_sound)
	new_sound.deletion_manager = deletion_manager


func _on_GunTriggerTimer_timeout():
	can_trigger = true


func _on_ShotTimerMiddle_timeout():
	can_shoot_middle = true


func _on_ShotTimerSides_timeout():
	can_shoot_sides = true


func _on_ShotgunTimer_timeout():
	can_shoot_shotgun = true
