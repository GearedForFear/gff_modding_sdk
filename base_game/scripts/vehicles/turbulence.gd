extends AmmoVehicle


export var damage: float = 44.0
export var reward: int = 16
export var burn: float = 10.0
export var ammo_cost: float = 12.0

var can_shoot_middle: bool = true
var can_shoot_left: bool = true
var can_shoot_right: bool = true
var glide: bool = false


func _physics_process(_delta):
	if alive:
		if controls == null:
			pass
		else:
			if can_shoot_middle and ammo >= ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				ammo -= ammo_cost
				can_shoot_middle = false
				get_node("../MiddleTimer").start()
				pools.get_grenade().start($ShotPositionMiddle.global_transform, \
						damage, reward, burn, self)
				$ShotAudioMiddle.play()
			
			if can_shoot_left and ammo >= ammo_cost \
					and Input.is_action_pressed(controls.weapon_left):
				ammo -= ammo_cost
				can_shoot_left = false
				get_node("../LeftTimer").start()
				pools.get_grenade().start($ShotPositionLeft.global_transform, \
						damage, reward, burn, self)
				$ShotAudioLeft.play()
			
			if can_shoot_right and ammo >= ammo_cost \
					and Input.is_action_pressed(controls.weapon_right):
				ammo -= ammo_cost
				can_shoot_right = false
				get_node("../RightTimer").start()
				pools.get_grenade().start($ShotPositionRight.global_transform, \
						damage, reward, burn, self)
				$ShotAudioRight.play()
			
			if Input.is_action_just_pressed(controls.weapon_back):
				if glide:
					get_node("../AnimationPlayer").play("out_in")
					$WingsOutAudio.play()
				else:
					get_node("../AnimationPlayer").play("in_out")
					$WingsInAudio.play()
				glide = !glide
	
	if glide:
		apply_central_impulse(transform.basis.y * clamp((linear_velocity \
				* Vector3(1, 0, 1)).length() - 20, 0, 10) * 3)


func get_vehicle_name() -> String:
	return "Turbulence"


func _on_MiddleTimer_timeout():
	can_shoot_middle = true


func _on_LeftTimer_timeout():
	can_shoot_left = true


func _on_RightTimer_timeout():
	can_shoot_right = true
