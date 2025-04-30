extends AmmoVehicle


export var missile_damage: float = 40.0
export var missile_reward: int = 15
export var missile_burn: float = 10.0
export var missile_ammo_cost: float = 10.0

var front_can_shoot: bool = true
var back_can_shoot: bool = true
var left_can_shoot: bool = true
var right_can_shoot: bool = true


func _physics_process(_delta):
	if alive:
		if controls == null:
			pass
		else:
			if front_can_shoot and ammo >= missile_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				front_can_shoot = false
				get_node("../FrontTimer").start()
				instantiate_missile(\
						$ShotPositionFront.global_transform, 0, false)
				
			if back_can_shoot and ammo >= missile_ammo_cost \
					and Input.is_action_pressed(controls.weapon_back):
				back_can_shoot = false
				get_node("../BackTimer").start()
				instantiate_missile(\
						$ShotPositionFront.global_transform, 0, true)
				
			if left_can_shoot and ammo >= missile_ammo_cost \
					and Input.is_action_pressed(controls.weapon_left):
				left_can_shoot = false
				get_node("../LeftTimer").start()
				instantiate_missile(\
						$ShotPositionFront.global_transform, -10, false)
				
			if right_can_shoot and ammo >= missile_ammo_cost \
					and Input.is_action_pressed(controls.weapon_right):
				right_can_shoot = false
				get_node("../RightTimer").start()
				instantiate_missile(\
						$ShotPositionFront.global_transform, 10, false)


func instantiate_missile(var start_position: Transform, var direction: int, \
		var moving_target: bool) -> Projectile:
	ammo -= missile_ammo_cost
	var new_missile: Projectile = pools.get_homing_missile()
	new_missile.start(start_position, missile_damage, missile_reward, \
			missile_burn, self)
	new_missile.target = global_transform.basis.y * 5 \
			+ global_transform.basis.z * -30 + global_translation \
			+ global_transform.basis.x * direction
	new_missile.moving_target = moving_target
	return new_missile


func get_vehicle_name() -> String:
	return "Suicide Door"


func _on_FrontTimer_timeout():
	front_can_shoot = true


func _on_BackTimer_timeout():
	back_can_shoot = true


func _on_LeftTimer_timeout():
	left_can_shoot = true


func _on_RightTimer_timeout():
	right_can_shoot = true
