extends LevelVehicle


enum cartridge_out {NONE, LINK, CASE}

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
var next_out_middle: int = cartridge_out.NONE
var next_out_sides: int = cartridge_out.NONE


func _ready():
	if controls == null:
		driver_name = "Well Raised"
	
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		delete($MGMeshLeft/MuzzleFlash/CPUParticles)
		delete($MGMeshMiddle/MuzzleFlash/CPUParticles)
		delete($MGMeshRight/MuzzleFlash/CPUParticles)
		delete($ShotgunFlashLeft/CPUParticles)
		delete($ShotgunFlashLeft/CPUParticles2)
		delete($ShotgunFlashRight/CPUParticles)
		delete($ShotgunFlashRight/CPUParticles2)
	else:
		delete($MGMeshLeft/MuzzleFlash/Particles)
		delete($MGMeshMiddle/MuzzleFlash/Particles)
		delete($MGMeshRight/MuzzleFlash/Particles)
		delete($ShotgunFlashLeft/Particles)
		delete($ShotgunFlashLeft/Particles2)
		delete($ShotgunFlashRight/Particles)
		delete($ShotgunFlashRight/Particles2)


func _physics_process(_delta):
	match next_out_middle:
		cartridge_out.LINK:
			instantiate_cartridge($MGMeshMiddle, true)
			next_out_middle = cartridge_out.CASE
		cartridge_out.CASE:
			instantiate_cartridge($MGMeshMiddle, false)
			next_out_middle = cartridge_out.NONE
	
	match next_out_sides:
		cartridge_out.LINK:
			instantiate_cartridge($MGMeshLeft, true)
			instantiate_cartridge($MGMeshRight, true)
			next_out_sides = cartridge_out.CASE
		cartridge_out.CASE:
			instantiate_cartridge($MGMeshLeft, false)
			instantiate_cartridge($MGMeshRight, false)
			next_out_sides = cartridge_out.NONE
	
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
		shoot_middle()
	elif remaining_shots_sides > 0 and can_shoot_sides:
		shoot_sides()
	elif not (get_node("../ShotTimerMiddle").is_stopped() \
			and get_node("../ShotTimerSides").is_stopped()):
		get_node("../GunTriggerTimer").start()


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


func shoot_middle():
	xp += bullet_xp
	can_shoot_middle = false
	get_node("../ShotTimerMiddle").start()
	remaining_shots_middle -= 1
	next_out_middle = cartridge_out.LINK
	shoot_front($MGMeshMiddle)


func shoot_sides():
	xp += bullet_xp
	can_shoot_sides = false
	get_node("../ShotTimerSides").start()
	remaining_shots_sides -= 1
	next_out_sides = cartridge_out.LINK
	shoot_front($MGMeshLeft)
	shoot_front($MGMeshRight)


func shoot_left():
	xp += shotgun_xp
	can_shoot_shotgun = false
	get_node("../ShotgunTimer").start()
	
	apply_central_impulse(transform.basis.x * -shotgun_blast * level)
	
	shoot_shotgun($ShotgunPositionFrontLeft)
	shoot_shotgun($ShotgunPositionBackLeft)
	
	for n in $ShotgunFlashLeft.get_children():
		n.restart()
		n.emitting = true


func shoot_right():
	xp += shotgun_xp
	can_shoot_shotgun = false
	get_node("../ShotgunTimer").start()
	
	apply_central_impulse(transform.basis.x * shotgun_blast * level)
	
	shoot_shotgun($ShotgunPositionFrontRight)
	shoot_shotgun($ShotgunPositionBackRight)
	
	for n in $ShotgunFlashRight.get_children():
		n.restart()
		n.emitting = true


func shoot_front(var gun: MeshInstance):
	var new_bullet: Area
	if level == 5:
		new_bullet = pools.get_acid_bullet()
		new_bullet.start(gun.get_node("ShotPosition").global_transform, \
				acid_bullet_damage, bullet_reward, bullet_burn, self)
		new_bullet.acid_duration = acid_bullet_duration
	else:
		new_bullet = pools.get_bullet()
		new_bullet.start(gun.get_node("ShotPosition").global_transform, \
				bullet_damage, bullet_reward, bullet_burn, self)
	new_bullet.play_audio_lmg()
	
	var flash: GeometryInstance = gun.get_child(0).get_child(0)
	flash.restart()
	flash.emitting = true


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
			new_bullet = pools.get_acid_bullet()
			new_bullet.start(n.global_transform, shotgun_acid_damage, \
					shotgun_reward, shotgun_burn, self)
			new_bullet.acid_duration = shotgun_acid_duration
		else:
			new_bullet = pools.get_bullet()
			new_bullet.start(n.global_transform, shotgun_damage, \
					shotgun_reward, shotgun_burn, self)
		if n.name == "ShotPositionLeft":
			new_bullet.play_audio_shotgun()


func instantiate_cartridge(var gun: MeshInstance, var link: bool):
	if link:
		var new_link: DynamicShadowBody = pools.get_cartridge_link()
		new_link.start(gun.get_node("CartridgeExit").global_transform)
		new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 - 10)\
				/ 10000, (new_link.transform.basis.x * -1 \
				+ new_link.transform.basis.y) * 0.004)
	else:
		var new_case: DynamicShadowBody = pools.get_cartridge_case()
		new_case.start(gun.get_node("CartridgeExit").global_transform)
		new_case.apply_central_impulse(new_case.transform.basis.x * -0.006 \
				+ new_case.transform.basis.y * 0.004)


func _on_GunTriggerTimer_timeout():
	can_trigger = true


func _on_ShotTimerMiddle_timeout():
	can_shoot_middle = true


func _on_ShotTimerSides_timeout():
	can_shoot_sides = true


func _on_ShotgunTimer_timeout():
	can_shoot_shotgun = true
