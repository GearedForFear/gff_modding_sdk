extends AmmoVehicle


const PEARL_TEETH: ShaderMaterial = preload(
		"res://resources/materials/vehicles/simple_part_cull_disabled/pearl.material")
const GLOW_TEETH: ShaderMaterial = preload(
		"res://resources/materials/vehicles/simple_part_cull_disabled/glow.material")
const GOLD_TEETH: ShaderMaterial = preload(
		"res://resources/materials/vehicles/simple_part_cull_disabled/gold.material")

export var missile_damage: float = 40.0
export var missile_reward: int = 15
export var missile_burn: float = 10.0
export var missile_ammo_cost: float = 10.0

var can_shoot: bool = true


func _ready():
	if controls != null:
		var skin: String = random_skin("res://resources/materials/vehicles/missilodon/",
				"")
		match skin:
			"pearl.material":
				$Teeth.set_surface_material(0, PEARL_TEETH)
			"glow.material":
				$Teeth.set_surface_material(0, GLOW_TEETH)
			"gold.material":
				$Teeth.set_surface_material(0, GOLD_TEETH)


func _physics_process(_delta):
	if alive:
		steer_target = 0.0
		
		if controls == null:
			pass
		else:
			if can_shoot and ammo >= missile_ammo_cost:
					if Input.is_action_pressed(controls.weapon_front):
						ammo -= missile_ammo_cost
						can_shoot = false
					elif Input.is_action_pressed(controls.weapon_back):
						ammo -= missile_ammo_cost
						can_shoot = false
			
			MonsterTruckSteering.use([$WheelBackLeft, $WheelBackRight],
					Input.is_action_pressed(controls.weapon_left),
					Input.is_action_pressed(controls.weapon_right))


func get_vehicle_name() -> String:
	return "Missilodon"
