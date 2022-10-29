extends AmmoVehicle


const Grenade: PackedScene \
		= preload("res://scenes/weapon_components/grenade.tscn")

export var damage: float = 44.0
export var reward: int = 16
export var burn: float = 10.0
export var ammo_cost: float = 12.0

var can_shoot_middle: bool = true
var can_shoot_left: bool = true
var can_shoot_right: bool = true
var glide: bool = false


func _ready():
	if controls == null:
		driver_name = "Turbulence"
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
			if can_shoot_middle and ammo >= ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				ammo -= ammo_cost
				can_shoot_middle = false
				get_node("../MiddleTimer").start()
				$ShotPositionMiddle.add_child(instantiate_grenade())
			
			if can_shoot_left and ammo >= ammo_cost \
					and Input.is_action_pressed(controls.weapon_left):
				ammo -= ammo_cost
				can_shoot_left = false
				get_node("../LeftTimer").start()
				$ShotPositionLeft.add_child(instantiate_grenade())
			
			if can_shoot_right and ammo >= ammo_cost \
					and Input.is_action_pressed(controls.weapon_right):
				ammo -= ammo_cost
				can_shoot_right = false
				get_node("../RightTimer").start()
				$ShotPositionRight.add_child(instantiate_grenade())
			
			if Input.is_action_just_pressed(controls.weapon_back):
				if glide:
					get_node("../AnimationPlayer").play("out_in")
				else:
					get_node("../AnimationPlayer").play("in_out")
				glide = !glide
	
	if glide:
		apply_central_impulse(transform.basis.y * clamp((linear_velocity \
				* Vector3(1, 0, 1)).length() - 20, 0, 10) * 3)


func instantiate_grenade() -> Area:
	var new_grenade: Area = Grenade.instance()
	new_grenade.damage = damage
	new_grenade.reward = reward
	new_grenade.burn = burn
	new_grenade.shooter = self
	new_grenade.deletion_manager = deletion_manager
	return new_grenade


func _on_MiddleTimer_timeout():
	can_shoot_middle = true


func _on_LeftTimer_timeout():
	can_shoot_left = true


func _on_RightTimer_timeout():
	can_shoot_right = true
