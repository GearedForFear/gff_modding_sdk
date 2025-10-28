extends AmmoVehicle


func _physics_process(_delta):
	if alive:
		if controls == null:
			pass
		else:
			if Input.is_action_pressed(controls.weapon_front):
				$LauncherFront.try_shoot(self, pools)
			
			if Input.is_action_pressed(controls.weapon_back):
				$LauncherBack.try_shoot(self, pools)
			
			if Input.is_action_pressed(controls.weapon_left):
				$LauncherLeft.try_shoot(self, pools)
			
			if Input.is_action_pressed(controls.weapon_right):
				$LauncherRight.try_shoot(self, pools)


func get_vehicle_name() -> String:
	return "Suicide Door"
