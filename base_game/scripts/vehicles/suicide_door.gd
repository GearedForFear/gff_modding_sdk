extends AmmoVehicle


func _physics_process(_delta):
	if not alive or controls == null:
		return
	
	if Input.is_action_pressed(controls.weapon_front):
		$LauncherFront.try_shoot(self, pools)
	
	if Input.is_action_pressed(controls.weapon_back):
		$LauncherBack.try_shoot(self, pools)
	
	if Input.is_action_pressed(controls.weapon_left):
		$LauncherLeft.try_shoot(self, pools)
	
	if Input.is_action_pressed(controls.weapon_right):
		$LauncherRight.try_shoot(self, pools)
