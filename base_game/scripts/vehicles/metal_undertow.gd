extends AmmoVehicle


export var damage: float = 20.0
export var reward: int = 10
export var burn: float = 1.0
export var ammo_cost: float = 10.0

var can_shoot_any: bool = true
var can_shoot_front: bool = true
var can_shoot_left: bool = true
var can_shoot_right: bool = true
var saws: Array


func _ready():
	if controls != null:
		random_skin("res://resources/materials/vehicles/metal_undertow/", "")


func _physics_process(_delta):
	var use_magnet: bool = false
	if alive:
		if controls == null:
			if can_shoot_any and ammo >= ammo_cost:
				var collider: PhysicsBody = $ShotPositionMiddle.get_collider()
				if can_shoot_front and collider != null \
						and collider.is_in_group("combat_vehicle") \
						and collider.scoreboard_record.score >= 100:
					shoot($ShotPositionMiddle)
					can_shoot_front = false
					get_node("../ShotTimerFront").start()
					get_node("../StuckTimer").start()
				else:
					collider = $ShotPositionLeft.get_collider()
					if can_shoot_left and collider != null \
							and collider.is_in_group("combat_vehicle") \
							and collider.scoreboard_record.score >= 100:
						shoot($ShotPositionLeft)
						can_shoot_left = false
						get_node("../ShotTimerLeft").start()
						get_node("../StuckTimer").start()
					else:
						collider = $ShotPositionRight.get_collider()
						if can_shoot_right and collider != null \
								and collider.is_in_group("combat_vehicle") \
								and collider.scoreboard_record.score >= 100:
							shoot($ShotPositionRight)
							can_shoot_right = false
							get_node("../ShotTimerRight").start()
							get_node("../StuckTimer").start()
		else:
			if can_shoot_any and ammo >= ammo_cost:
				if can_shoot_front and Input.is_action_pressed(\
						controls.weapon_front):
					shoot($ShotPositionMiddle)
					can_shoot_front = false
					get_node("../ShotTimerFront").start()
				elif can_shoot_left and Input.is_action_pressed(\
						controls.weapon_left):
					shoot($ShotPositionLeft)
					can_shoot_left = false
					get_node("../ShotTimerLeft").start()
				elif can_shoot_right and Input.is_action_pressed(\
						controls.weapon_right):
					shoot($ShotPositionRight)
					can_shoot_right = false
					get_node("../ShotTimerRight").start()
			if Input.is_action_pressed(controls.weapon_back) \
					and not saws.empty():
				use_magnet = true
	pull(use_magnet)


func shoot(var launcher: RayCast):
	ammo -= ammo_cost
	can_shoot_any = false
	get_node("../ShotTimerAny").start()
	
	var new_buzzsaw: Area = pools.get_buzzsaw()
	new_buzzsaw.start(launcher.global_transform, damage, reward, \
			burn, self)
	new_buzzsaw.play_audio_shot()
	saws.append(new_buzzsaw)


func pull(var b: bool):
	if b:
		var position: Vector3 = $PullParticles.global_translation
		for n in saws:
			apply_central_impulse((n.magnet(position) \
					- position).normalized() * 100)
	else:
		for n in saws:
			n.hide_line()
	if gles3:
		$PullParticles.emitting = b
	else:
		$PullCPUParticles.emitting = b
	$LoopingAudio/MagnetAudio.stream_paused = not b


func get_vehicle_name() -> String:
	return "Metal Undertow"


func _on_ShotTimerAny_timeout():
	can_shoot_any = true


func _on_ShotTimerFront_timeout():
	can_shoot_front = true


func _on_ShotTimerLeft_timeout():
	can_shoot_left = true


func _on_ShotTimerRight_timeout():
	can_shoot_right = true
