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
	if controls == null:
		driver_name = "Grave Mistake"


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
					and collider_front.score >= 100:
				shoot(true, $ShotPositionFront)
				ammo -= bullet_ammo_cost
				front_can_shoot = false
				next_out_front = cartridge_out.LINK
				get_node("../FrontTimer").start()
			else:
				shoot(false, $ShotPositionFront)
			
			if back_can_shoot and ammo >= bullet_ammo_cost \
					and collider_back != null \
					and collider_back.is_in_group("combat_vehicle") \
					and collider_back.score >= 100:
				shoot(true, $ShotPositionBack)
				ammo -= bullet_ammo_cost
				back_can_shoot = false
				next_out_back = cartridge_out.LINK
				get_node("../BackTimer").start()
			else:
				shoot(false, $ShotPositionBack)
		else:
			if front_can_shoot and ammo >= bullet_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				shoot(true, $ShotPositionFront)
				ammo -= bullet_ammo_cost
				front_can_shoot = false
				next_out_front = cartridge_out.LINK
				get_node("../FrontTimer").start()
			else:
				shoot(false, $ShotPositionFront)
			
			if back_can_shoot and ammo >= bullet_ammo_cost \
					and Input.is_action_pressed(controls.weapon_back):
				shoot(true, $ShotPositionBack)
				ammo -= bullet_ammo_cost
				back_can_shoot = false
				next_out_back = cartridge_out.LINK
				get_node("../BackTimer").start()
			else:
				shoot(false, $ShotPositionBack)
			
			if Input.is_action_pressed(controls.weapon_left):
				steer_target = 1.0
			
			if Input.is_action_pressed(controls.weapon_right):
				steer_target -= 1.0
		
		steer_target *= STEER_LIMIT
		back_steering = move_toward(back_steering, steer_target, STEER_SPEED)
		$WheelBackLeft.steering = back_steering
		$WheelBackRight.steering = back_steering
	else:
		shoot(false, $ShotPositionFront)
		shoot(false, $ShotPositionBack)


func shoot(var b: bool, var gun: RayCast):
	if b:
		var new_bullet: Area
		new_bullet = pools.get_bullet()
		new_bullet.start(gun.global_transform, bullet_damage, bullet_reward,
				bullet_burn, self)
		new_bullet.play_audio_lmg()
		
		if gles3:
			gun.get_node("MuzzleFlash").emitting = true
		else:
			gun.get_node("CPUMuzzleFlash").emitting = true
	else:
		if gles3:
			gun.get_node("MuzzleFlash").emitting = false
		else:
			gun.get_node("CPUMuzzleFlash").emitting = false


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


func _on_FrontTimer_timeout():
	front_can_shoot = true


func _on_BackTimer_timeout():
	back_can_shoot = true
