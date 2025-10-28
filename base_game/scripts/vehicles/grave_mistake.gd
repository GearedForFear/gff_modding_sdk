extends AmmoVehicle


enum cartridge_out {NONE, LINK, CASE}

export var bullet_damage: float = 4.5
export var bullet_reward: int = 1
export var bullet_burn: float = 0.4
export var bullet_ammo_cost: float = 2.1

var front_can_shoot: bool = true
var back_can_shoot: bool = true
var back_steering: float = 0.0
var next_out_front: int = cartridge_out.NONE
var next_out_back: int = cartridge_out.NONE


func _ready():
	if controls != null:
		random_skin("res://resources/materials/vehicles/grave_mistake/",
				"res://resources/materials/vehicles/wheels_gm/")
	
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		delete($ShotPositionFront/MuzzleFlash/CPUParticles)
		delete($ShotPositionBack/MuzzleFlash/CPUParticles)
	else:
		delete($ShotPositionFront/MuzzleFlash/Particles)
		delete($ShotPositionBack/MuzzleFlash/Particles)


func _physics_process(_delta):
	match next_out_front:
		cartridge_out.LINK:
			instantiate_cartridge($ShotPositionFront/CartridgeExit, true)
			next_out_front = cartridge_out.CASE
		cartridge_out.CASE:
			instantiate_cartridge($ShotPositionFront/CartridgeExit, false)
			next_out_front = cartridge_out.NONE
	
	match next_out_back:
		cartridge_out.LINK:
			instantiate_cartridge($ShotPositionBack/CartridgeExit, true)
			next_out_back = cartridge_out.CASE
		cartridge_out.CASE:
			instantiate_cartridge($ShotPositionBack/CartridgeExit, false)
			next_out_back = cartridge_out.NONE
	
	if alive:
		steer_target = 0.0
		
		if controls == null:
			var collider_front: PhysicsBody \
					= $ShotPositionFront.get_collider()
			var collider_back: PhysicsBody \
					= $ShotPositionBack.get_collider()
			
			if front_can_shoot and ammo >= bullet_ammo_cost \
					and collider_front != null \
					and collider_front.is_in_group("combat_vehicle") \
					and collider_front.scoreboard_record.score >= 100:
				shoot($ShotPositionFront)
				ammo -= bullet_ammo_cost
				front_can_shoot = false
				next_out_front = cartridge_out.LINK
				get_node("../FrontTimer").start()
			
			if back_can_shoot and ammo >= bullet_ammo_cost \
					and collider_back != null \
					and collider_back.is_in_group("combat_vehicle") \
					and collider_back.scoreboard_record.score >= 100:
				shoot($ShotPositionBack)
				ammo -= bullet_ammo_cost
				back_can_shoot = false
				next_out_back = cartridge_out.LINK
				get_node("../BackTimer").start()
		else:
			if front_can_shoot and ammo >= bullet_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				shoot($ShotPositionFront)
				ammo -= bullet_ammo_cost
				front_can_shoot = false
				next_out_front = cartridge_out.LINK
				get_node("../FrontTimer").start()
			
			if back_can_shoot and ammo >= bullet_ammo_cost \
					and Input.is_action_pressed(controls.weapon_back):
				shoot($ShotPositionBack)
				ammo -= bullet_ammo_cost
				back_can_shoot = false
				next_out_back = cartridge_out.LINK
				get_node("../BackTimer").start()
			
			MonsterTruckSteering.use([$WheelBackLeft, $WheelBackRight],
					Input.is_action_pressed(controls.weapon_left),
					Input.is_action_pressed(controls.weapon_right))


func shoot(var gun: RayCast):
	var new_bullet: Area
	new_bullet = pools.get_bullet()
	new_bullet.start(gun.global_transform, bullet_damage, bullet_reward,
			bullet_burn, self)
	new_bullet.play_audio_lmg()
	
	var flash: GeometryInstance = gun.get_child(0).get_child(0)
	flash.restart()
	flash.emitting = true


func instantiate_cartridge(var exit: Position3D, var link: bool):
	if link:
		var new_link: DynamicShadowBody = pools.get_cartridge_link()
		new_link.start(exit.global_transform)
		new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 - 10)\
				/ 10000, (new_link.transform.basis.x * 3 \
				+ new_link.transform.basis.y) * 0.004)
	else:
		var new_case: DynamicShadowBody = pools.get_cartridge_case()
		new_case.start(exit.global_transform)
		new_case.apply_central_impulse(new_case.transform.basis.x * 0.018 \
				+ new_case.transform.basis.y * 0.004)


func get_vehicle_name() -> String:
	return "Grave Mistake"


func _on_FrontTimer_timeout():
	front_can_shoot = true


func _on_BackTimer_timeout():
	back_can_shoot = true
