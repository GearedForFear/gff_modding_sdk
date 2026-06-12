extends AmmoVehicle


export var cooldown_resource: Resource

var shared_cooldown: int = 0
var saws: Array


func _physics_process(_delta):
	shared_cooldown -= 1
	
	var enable_magnet: bool = false
	if alive:
		if controls == null:
			if process_buzzsaws_npc():
				reset_stuck_timer()
		
		else:
			process_buzzsaws_player()
			
			if Input.is_action_pressed(controls.weapon_back) \
					and not saws.empty():
				enable_magnet = true
	
	pull(enable_magnet)


func process_buzzsaws_npc() -> bool:
	if shared_cooldown > 0:
		return false
	
	for n in [$LauncherFront, $LauncherLeft, $LauncherRight]:
		if is_good_target(n):
			try_shoot(n)
			return true
	
	return false


func process_buzzsaws_player():
	if shared_cooldown > 0:
		return
	
	if Input.is_action_pressed(controls.weapon_front) \
			and try_shoot($LauncherFront):
		return
	
	if Input.is_action_pressed(controls.weapon_left) \
			and try_shoot($LauncherLeft):
		return
	
	if Input.is_action_pressed(controls.weapon_right) \
			and try_shoot($LauncherRight):
		return


func try_shoot(var launcher: RayCast) -> bool:
	var has_shot: bool = launcher.try_shoot(self)
	if has_shot:
		shared_cooldown = cooldown_resource.length
	return has_shot


func pull(var enable: bool):
	if enable:
		var position: Vector3 = $PullParticles.global_translation
		for n in saws:
			apply_central_impulse((n.magnet(position) \
					- position).normalized() * 100)
	else:
		for n in saws:
			n.hide_line()
	if gles3:
		$PullParticles.emitting = enable
	else:
		$PullCPUParticles.emitting = enable
	$LoopingAudio/MagnetAudio.stream_paused = not enable
