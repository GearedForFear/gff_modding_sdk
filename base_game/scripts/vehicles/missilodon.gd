extends AmmoVehicle


const PEARL_TEETH: ShaderMaterial = preload(
		"res://resources/materials/vehicles/simple_part_cull_disabled/pearl.material")
const GLOW_TEETH: ShaderMaterial = preload(
		"res://resources/materials/vehicles/simple_part_cull_disabled/glow.material")
const GOLD_TEETH: ShaderMaterial = preload(
		"res://resources/materials/vehicles/simple_part_cull_disabled/gold.material")

var missiles: Array


func _ready():
	if controls != null:
		var skin: String = random_skin(
				"res://resources/materials/vehicles/missilodon/", "")
		match skin:
			"pearl.material":
				$Teeth.set_surface_material(0, PEARL_TEETH)
			"glow.material":
				$Teeth.set_surface_material(0, GLOW_TEETH)
			"gold.material":
				$Teeth.set_surface_material(0, GOLD_TEETH)


func _physics_process(_delta):
	if not alive or controls == null:
		return
	
	if Input.is_action_pressed(controls.weapon_front):
		$Launcher.try_shoot(self, pools)
	
	if Input.is_action_pressed(controls.weapon_back):
		MissileRemote.down(missiles)
	
	if Input.is_action_pressed(controls.weapon_left):
		MissileRemote.left(missiles)
	
	if Input.is_action_pressed(controls.weapon_right):
		MissileRemote.right(missiles)
	
	if missiles.empty():
		MonsterTruckSteering.use([$WheelBackLeft, $WheelBackRight],
				Input.is_action_pressed(controls.weapon_left),
				Input.is_action_pressed(controls.weapon_right))
	else:
		MonsterTruckSteering.use([$WheelBackLeft, $WheelBackRight],
				false, false)
