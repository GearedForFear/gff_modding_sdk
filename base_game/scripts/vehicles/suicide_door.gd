extends AmmoVehicle


const Missile: PackedScene \
		= preload("res://scenes/weapon_components/missile.tscn")

export var missile_damage: float = 40.0
export var missile_reward: int = 15
export var missile_burn: float = 10.0
export var missile_ammo_cost: float = 10.0

var can_shoot: bool = true
var back_can_shoot: bool = true
var left_can_shoot: bool = true
var right_can_shoot: bool = true


func _ready():
	if controls == null:
		driver_name = "Suicide Door"
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


func _physics_process(_delta):
	if alive:
		if controls == null:
			pass
		else:
			if can_shoot and ammo >= missile_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				ammo -= missile_ammo_cost
				can_shoot = false
				get_node("../FrontTimer").start()
				$ShotPositionFront.add_child(instantiate_missile(0, false))
				
			if back_can_shoot and ammo >= missile_ammo_cost \
					and Input.is_action_pressed(controls.weapon_back):
				ammo -= missile_ammo_cost
				back_can_shoot = false
				get_node("../BackTimer").start()
				$ShotPositionBack.add_child(instantiate_missile(0, true))
				
			if left_can_shoot and ammo >= missile_ammo_cost \
					and Input.is_action_pressed(controls.weapon_left):
				ammo -= missile_ammo_cost
				left_can_shoot = false
				get_node("../LeftTimer").start()
				$ShotPositionLeft.add_child(instantiate_missile(-5, false))
				
			if right_can_shoot and ammo >= missile_ammo_cost \
					and Input.is_action_pressed(controls.weapon_right):
				ammo -= missile_ammo_cost
				right_can_shoot = false
				get_node("../RightTimer").start()
				$ShotPositionRight.add_child(instantiate_missile(5, false))


func instantiate_missile(var direction: int, var moving_target: bool) \
		-> Area:
	var new_missile: Area = Missile.instance()
	new_missile.damage = missile_damage
	new_missile.reward = missile_reward
	new_missile.burn = missile_burn
	new_missile.shooter = self
	new_missile.target = global_transform.basis.y * 5 \
			+ global_transform.basis.z * -30 + global_transform.origin \
			+ global_transform.basis.x * direction
	new_missile.moving_target = moving_target
	new_missile.deletion_manager = deletion_manager
	new_missile.gles3 = gles3
	return new_missile


func _on_FrontTimer_timeout():
	can_shoot = true
	
	
func _on_BackTimer_timeout():
	back_can_shoot = true
	
	
func _on_LeftTimer_timeout():
	left_can_shoot = true
	
	
func _on_RightTimer_timeout():
	right_can_shoot = true
