extends AmmoVehicle


const Sniper_Bullet: PackedScene \
		= preload("res://scenes/weapon_components/sniper_bullet.tscn")
const Chainsaw: PackedScene \
		= preload("res://scenes/weapon_components/chainsaw.tscn")
const ShotSoundSniper: PackedScene \
		= preload("res://scenes/weapon_components/shot_sound_sniper.tscn")

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


func _ready():
	if controls == null:
		driver_name = "Chain's Awe"
	if get_node("/root/RootControl/SettingsManager").shadow_casters <= 1:
		$BodyMesh.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontLeft/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontRight/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackLeft/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackRight/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$ChainsawFrontLeft.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$ChainsawFrontRight.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$ChainsawBackLeft.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$ChainsawBackRight.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$ChainsawLauncher.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF


func _physics_process(_delta):
	if alive:
		if controls == null:
			var collider: PhysicsBody = $ShotPositionSniper.get_collider()
			if can_shoot_sniper and ammo >= sniper_ammo_cost and \
					collider != null \
					and collider.is_in_group("combat_vehicle") \
					and collider.score >= 100:
				shoot_sniper()
				get_node("../StuckTimer").start()
		else:
			if can_shoot_sniper and ammo >= sniper_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				shoot_sniper()
			if ammo >= saw_ammo_cost \
					and Input.is_action_pressed(controls.weapon_left):
				saw_left(true)
			else:
				saw_left(false)
			if ammo >= saw_ammo_cost \
					and Input.is_action_pressed(controls.weapon_right):
				saw_right(true)
			else:
				saw_right(false)
			if can_shoot_launcher and ammo >= launcher_ammo_cost \
					and Input.is_action_pressed(controls.weapon_back):
				shoot_chainsaw()


func shoot_sniper():
	ammo -= sniper_ammo_cost
	can_shoot_sniper = false
	get_node("../SniperTimer").start()
	
	var new_bullet: Area = Sniper_Bullet.instance()
	$ShotPositionSniper.add_child(new_bullet)
	new_bullet.damage = sniper_damage
	new_bullet.reward = sniper_reward
	new_bullet.burn = sniper_burn
	new_bullet.shooter = self
	new_bullet.deletion_manager = deletion_manager
	
	var new_sound: AudioStreamPlayer3D = ShotSoundSniper.instance()
	$ShotPositionSniper.add_child(new_sound)
	new_sound.deletion_manager = deletion_manager
	
	if gles3:
		$MuzzleFlash.emitting = true
	else:
		$CPUMuzzleFlash.emitting = true


func saw_left(var b: bool):
	$ChainsawAudioLeft.stream_paused = not b
	if b:
		ammo -= saw_ammo_cost
		if left_saws_up:
			get_node("../AnimationPlayer").play("left_saws_down")
			left_saws_up = false
		var overalpping: Array = $SawAreaLeft.get_overlapping_bodies()
		overalpping.erase(self)
		if overalpping.empty():
			$CuttingAudioLeft.stream_paused = true
			if gles3:
				$SawSparksFrontLeft.emitting = false
				$SawSparksBackLeft.emitting = false
			else:
				$SawCPUSparksFrontLeft.emitting = false
				$SawCPUSparksBackLeft.emitting = false
		else:
			$CuttingAudioLeft.stream_paused = false
			if gles3:
				$SawSparksFrontLeft.emitting = true
				$SawSparksBackLeft.emitting = true
			else:
				$SawCPUSparksFrontLeft.emitting = true
				$SawCPUSparksBackLeft.emitting = true
			apply_central_impulse(transform.basis.x * saw_push)
			for n in overalpping:
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
			$CuttingAudioLeft.stream_paused = true
			if gles3:
				$SawSparksFrontLeft.emitting = false
				$SawSparksBackLeft.emitting = false
			else:
				$SawCPUSparksFrontLeft.emitting = false
				$SawCPUSparksBackLeft.emitting = false


func saw_right(var b: bool):
	$ChainsawAudioRight.stream_paused = not b
	if b:
		ammo -= saw_ammo_cost
		if right_saws_up:
			get_node("../AnimationPlayer2").play("right_saws_down")
			right_saws_up = false
		var overalpping: Array = $SawAreaRight.get_overlapping_bodies()
		overalpping.erase(self)
		if overalpping.empty():
			$CuttingAudioRight.stream_paused = true
			if gles3:
				$SawSparksFrontRight.emitting = false
				$SawSparksBackRight.emitting = false
			else:
				$SawCPUSparksFrontRight.emitting = false
				$SawCPUSparksBackRight.emitting = false
		else:
			$CuttingAudioRight.stream_paused = false
			if gles3:
				$SawSparksFrontRight.emitting = true
				$SawSparksBackRight.emitting = true
			else:
				$SawCPUSparksFrontRight.emitting = true
				$SawCPUSparksBackRight.emitting = true
			apply_central_impulse(transform.basis.x * -saw_push)
			for n in overalpping:
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
			$CuttingAudioRight.stream_paused = true
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
	
	var new_chainsaw: Area = Chainsaw.instance()
	$ShotPositionLauncher.add_child(new_chainsaw)
	new_chainsaw.damage = launcher_damage
	new_chainsaw.reward = launcher_reward
	new_chainsaw.burn = launcher_burn
	new_chainsaw.shooter = self
	new_chainsaw.deletion_manager = deletion_manager


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
