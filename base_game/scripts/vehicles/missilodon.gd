extends AmmoVehicle


var missiles: Array


func _physics_process(_delta):
	if not alive or controls == null:
		return
	
	if Input.is_action_pressed(controls.weapon_front):
		$Launcher.try_shoot(self)
	
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
