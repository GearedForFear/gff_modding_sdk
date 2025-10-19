extends AmmoVehicle


export var sniper_damage: float = 40.0
export var sniper_reward: int = 15
export var sniper_burn: float = 4.0
export var sniper_ammo_cost: float = 18.0

export var saw_damage: float = 2.0
export var saw_reward: int = 1
export var saw_burn: float = 0.1
export var saw_push: int = 250
export var saw_ammo_cost: float = 0.12

export var launcher_damage: float = 40.0
export var launcher_reward: int = 20
export var launcher_burn: float = 0.1
export var launcher_ammo_cost: float = 18.0

var can_shoot_sniper: bool = true
var can_shoot_launcher: bool = true
var left_saws_up: bool = true
var right_saws_up: bool = true
var left_saws_active: bool = false
var right_saws_active: bool = false

var chainsaw_skin: ShaderMaterial


func _ready():
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		delete($MuzzleFlash/CPUParticles)
	else:
		delete($MuzzleFlash/Particles)
	var path_ending: String = random_skin("", "")
	path_ending = path_ending.replace("flame", "stock")
	chainsaw_skin = ResourceLoader.load(
			"res://resources/materials/weapon_components/chainsaw/"
			+ path_ending, "ShaderMaterial")


func _physics_process(_delta):
	if alive:
		if controls == null:
			var collider: PhysicsBody = $ShotPositionSniper.get_collider()
			if can_shoot_sniper and ammo >= sniper_ammo_cost and \
					collider != null \
					and collider.is_in_group("combat_vehicle") \
					and collider.scoreboard_record.score >= 100:
				shoot_sniper()
				get_node("../StuckTimer").start()
			
			collider = $LauncherRay.get_collider()
			if can_shoot_launcher and ammo >= launcher_ammo_cost and \
					collider != null \
					and collider.is_in_group("combat_vehicle") \
					and collider.scoreboard_record.score >= 100:
				shoot_chainsaw()
				get_node("../StuckTimer").start()
		else:
			if can_shoot_sniper and ammo >= sniper_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				shoot_sniper()
			left_saws_active = ammo >= saw_ammo_cost \
					and Input.is_action_pressed(controls.weapon_left)
			right_saws_active = ammo >= saw_ammo_cost \
					and Input.is_action_pressed(controls.weapon_right)
			if can_shoot_launcher and ammo >= launcher_ammo_cost \
					and Input.is_action_pressed(controls.weapon_back):
				shoot_chainsaw()
	saw_left(left_saws_active)
	saw_right(right_saws_active and (not alive or ammo >= saw_ammo_cost))


func shoot_sniper():
	ammo -= sniper_ammo_cost
	can_shoot_sniper = false
	get_node("../SniperTimer").start()
	
	var new_bullet: StraightProjectile = pools.get_sniper_bullet()
	new_bullet.start($ShotPositionSniper.global_transform, sniper_damage, \
			sniper_reward, sniper_burn, self)
	new_bullet.play_audio_sniper()
	
	$MuzzleFlash.get_child(0).emitting = true


func saw_left(var b: bool):
	$LoopingAudio/ChainsawAudioLeft.stream_paused = not b
	if b:
		if alive:
			ammo -= saw_ammo_cost
		if left_saws_up:
			get_node("../AnimationPlayer").play("left_saws_down")
			left_saws_up = false
		var overlapping: Array = $SawAreaLeft.get_overlapping_bodies()
		overlapping.erase(self)
		if overlapping.empty():
			$LoopingAudio/CuttingAudioLeft.stream_paused = true
			if gles3:
				$SawSparksFrontLeft.emitting = false
				$SawSparksBackLeft.emitting = false
			else:
				$SawCPUSparksFrontLeft.emitting = false
				$SawCPUSparksBackLeft.emitting = false
		else:
			$LoopingAudio/CuttingAudioLeft.stream_paused = false
			if gles3:
				$SawSparksFrontLeft.emitting = true
				$SawSparksBackLeft.emitting = true
			else:
				$SawCPUSparksFrontLeft.emitting = true
				$SawCPUSparksBackLeft.emitting = true
			apply_central_impulse(transform.basis.x * saw_push)
			for n in overlapping:
				if n.is_in_group("combat_vehicle"):
					var payout: int = n.damage(saw_damage, saw_reward, \
							saw_burn, self)
					reward(payout)
					if payout > 0 and (not $MoneyAudioRight.playing \
							or $MoneyAudioRight.get_playback_position() > 0.1):
						$MoneyAudioRight.play()
	else:
		if not left_saws_up:
			get_node("../AnimationPlayer").play("left_saws_up")
			left_saws_up = true
			$LoopingAudio/CuttingAudioLeft.stream_paused = true
			if gles3:
				$SawSparksFrontLeft.emitting = false
				$SawSparksBackLeft.emitting = false
			else:
				$SawCPUSparksFrontLeft.emitting = false
				$SawCPUSparksBackLeft.emitting = false


func saw_right(var b: bool):
	$LoopingAudio/ChainsawAudioRight.stream_paused = not b
	if b:
		if alive:
			ammo -= saw_ammo_cost
		if right_saws_up:
			get_node("../AnimationPlayer2").play("right_saws_down")
			right_saws_up = false
		var overlapping: Array = $SawAreaRight.get_overlapping_bodies()
		overlapping.erase(self)
		if overlapping.empty():
			$LoopingAudio/CuttingAudioRight.stream_paused = true
			if gles3:
				$SawSparksFrontRight.emitting = false
				$SawSparksBackRight.emitting = false
			else:
				$SawCPUSparksFrontRight.emitting = false
				$SawCPUSparksBackRight.emitting = false
		else:
			$LoopingAudio/CuttingAudioRight.stream_paused = false
			if gles3:
				$SawSparksFrontRight.emitting = true
				$SawSparksBackRight.emitting = true
			else:
				$SawCPUSparksFrontRight.emitting = true
				$SawCPUSparksBackRight.emitting = true
			apply_central_impulse(transform.basis.x * -saw_push)
			for n in overlapping:
				if n.is_in_group("combat_vehicle"):
					var payout: int = n.damage(saw_damage, saw_reward, \
							saw_burn, self)
					reward(payout)
					if payout > 0 and (not $MoneyAudioRight.playing \
							or $MoneyAudioRight.get_playback_position() > 0.1):
						$MoneyAudioRight.play()
	else:
		if not right_saws_up:
			get_node("../AnimationPlayer2").play("right_saws_up")
			right_saws_up = true
			$LoopingAudio/CuttingAudioRight.stream_paused = true
			if gles3:
				$SawSparksFrontRight.emitting = false
				$SawSparksBackRight.emitting = false
			else:
				$SawCPUSparksFrontRight.emitting = false
				$SawCPUSparksBackRight.emitting = false


func shoot_chainsaw():
	ammo -= launcher_ammo_cost
	can_shoot_launcher = false
	get_node("../LauncherTimer").start()
	$LauncherAudio.play()
	
	var new_chainsaw: ArcProjectile = pools.get_chainsaw()
	new_chainsaw.start($ShotPositionLauncher.global_transform, launcher_damage,\
			launcher_reward, launcher_burn, self)
	new_chainsaw.get_node("MeshInstance").material_override = chainsaw_skin


func get_vehicle_name() -> String:
	return "Chain's Awe"


func _on_SniperTimer_timeout():
	can_shoot_sniper = true


func _on_LauncherTimer_timeout():
	can_shoot_launcher = true


func _on_AnimationPlayer_animation_finished(anim_name):
	if anim_name == "left_saws_down":
		get_node("../AnimationPlayer").play("left_saws_active")


func _on_AnimationPlayer2_animation_finished(anim_name):
	if anim_name == "right_saws_down":
		get_node("../AnimationPlayer2").play("right_saws_active")
