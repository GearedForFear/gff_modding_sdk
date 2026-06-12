class_name CombatVehicle
extends CustomizableVehicle


signal health_changed(new)
signal acid_changed(new, health, base_health)

enum ShieldModes {OFF, ABSORB, DEFLECT}

const STEER_SPEED: float = 0.03
const STEER_LIMIT: float = 0.4
const ACID_DAMAGE_PER_TICK: float = 0.1

export var master_body: bool = true

var steer_target: float = 0.0
var alive: bool = false
var max_drift_left: float = 20.0
var max_drift_right: float = -20.0
var acid_duration: int = 0
var acid_cause: CombatVehicle
var scoreboard_record: ScoreboardRecord
var target: Spatial
var controls: PlayerControls # null == cpu controlled
var replacement: CombatVehicle
var track: Spatial
var gameplay_manager: Node
var pools: Node
var shield_mode: int = ShieldModes.OFF

onready var health: float = body_values.base_health
onready var boost: Boost = body_values.boost
onready var gles3: bool = OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3


func _enter_tree():
	if target != null:
		# Ensure this function only runs the first time for each instance
		return
	
	weight = body_values.weight
	gameplay_manager = track.get_node("GameplayManager")
	assert(!gameplay_manager.pursuers.has(self))
	pools = track.get_node("Pools")
	target = gameplay_manager.get_node("NonPlayerPath/Waypoint0")
	if master_body:
		if controls == null:
			var viewport: Viewport = find_parent("Viewport")
			if viewport != null:
				viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
				viewport.render_target_clear_mode = \
						Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
			DeletionManager.add_to_garbage($CameraBase)
		else:
			DeletionManager.add_to_garbage(get_node("../StuckTimer"))
			if skins_implemented:
				set_skin(0)
		
		if is_in_group("heist_target"):
			get_parent().rotation = -track.get_node("TargetStartSpawn").rotation
			rotation = track.get_node("TargetStartSpawn").rotation
		else:
			global_transform.origin = track.get_node("StartSpawns").translation \
					+ get_node("../..").translation.rotated(Vector3.UP, \
					track.get_node("StartSpawns").rotation.y)
			rotation = track.get_node("StartSpawns").rotation
			gameplay_manager.pursuers.append(self)
			
			if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
				DeletionManager.add_to_garbage($ExplosionCPUParticles)
				DeletionManager.add_to_garbage($DeathCPUParticles)
				DeletionManager.add_to_garbage($DriftCPUParticles)
				DeletionManager.add_to_garbage($AcidCPUParticles)
			else:
				DeletionManager.add_to_garbage($ExplosionParticles)
				DeletionManager.add_to_garbage($DeathParticles)
				DeletionManager.add_to_garbage($DriftParticles)
				DeletionManager.add_to_garbage($AcidParticles)
				$ExplosionCPUParticles.name = "ExplosionParticles"
				$DeathCPUParticles.name = "DeathParticles"
				$DriftCPUParticles.name = "DriftParticles"
				$AcidCPUParticles.name = "AcidParticles"
		
		reset_physics_interpolation()


func _ready():
	boost.prepare(self)


func _physics_process(_delta):
	if master_body and controls != null \
			and Input.is_action_just_pressed(controls.pause):
		$CameraBase/Camera/AspectRatioContainer/Control/Pause.open(true)
		get_tree().paused = true
	
	if alive:
		var acceleration_factor: float
		
		if controls == null and target != null:
			var direction: Vector3 = global_translation.direction_to(\
					target.global_translation).rotated(Vector3.UP, \
					-rotation.y)
			steer_target = direction.x
			if direction.z < 0: # If the target is behind this vehicle:
				steer_target = clamp(steer_target * 1000, -1, 1)
			else:
				steer_target = clamp(steer_target, -1, 1)
			acceleration_factor = body_values.base_engine_force
		else:
			steer_target = Input.get_action_strength(controls.turn_left_strength) \
					- Input.get_action_strength(controls.turn_right_strength)
			brake = 0.0
			
			acceleration_factor = try_boost()
			
			if Input.is_action_pressed(controls.reverse):
				if acceleration_factor != 0.0:
					acceleration_factor = -acceleration_factor
				elif transform.basis.xform_inv(linear_velocity).x < -1:
					brake = Input.get_action_strength(controls.reverse)
				else:
					acceleration_factor = -body_values.base_engine_force \
							* Input.get_action_strength(\
							controls.reverse)
			elif acceleration_factor == 0.0:
				acceleration_factor = body_values.base_engine_force \
						* Input.get_action_strength(\
						controls.accelerate_strength)
			
			max_drift_left = clamp(max_drift_left + 0.2, 0, 20)
			max_drift_right = clamp(max_drift_right - 0.2, -20, 0)
			if Input.is_action_pressed(controls.drift) and ($WheelFrontLeft\
					.is_in_contact() or $WheelFrontRight.is_in_contact()):
				var impulse: float = clamp(steering * linear_velocity.length() \
						/ 10, max_drift_right, max_drift_left)
				apply_impulse(transform.basis.z * -0.8, transform.basis.x \
						* impulse * weight * -0.05)
				max_drift_left = clamp(max_drift_left - impulse, 0, 20)
				max_drift_right = clamp(max_drift_right - impulse, -20, 0)
				$LoopingAudio/DriftAudio.stream_paused = false
				for n in $DriftParticles.get_children():
					n.emitting = true
			else:
				$LoopingAudio/DriftAudio.stream_paused = true
				for n in $DriftParticles.get_children():
					n.emitting = false
			
			if Input.is_action_just_pressed(controls.respawn):
				get_viewport().stop()
				gameplay_manager.respawn(self)
		
		steer_target *= STEER_LIMIT
		var max_steer_left: float = move_toward(steering, -STEER_LIMIT, STEER_SPEED)
		var max_steer_right: float = move_toward(steering, STEER_LIMIT, STEER_SPEED)
		steering = clamp(steer_target, max_steer_left, max_steer_right)
		
		# Increase engine force at low speeds to make the initial acceleration 
		# faster.
		var speed = linear_velocity.length()
		if speed < 5 and speed != 0:
			engine_force = clamp(acceleration_factor * 5 / speed, \
					-abs(acceleration_factor) * 2, abs(acceleration_factor) * 2)
		else:
			engine_force = acceleration_factor
		
		if acid_duration > 0:
			reduce_health(ACID_DAMAGE_PER_TICK, acid_cause)
			acid_duration -= 1
			emit_signal("acid_changed", acid_duration * ACID_DAMAGE_PER_TICK,
					health, body_values.base_health)
			for n in $AcidParticles.get_children():
				n.emitting = true
		else:
			for n in $AcidParticles.get_children():
				n.emitting = false
	else:
		engine_force = 0.0
	
	if engine_force == 0.0:
		$LoopingAudio/EngineAudio.unit_size = \
				lerp($LoopingAudio/EngineAudio.unit_size, 0.1, 0.03)
	else:
		$LoopingAudio/EngineAudio.unit_size = \
				lerp($LoopingAudio/EngineAudio.unit_size, 1.0, 0.9)
	$LoopingAudio/EngineAudio.pitch_scale = \
			clamp(linear_velocity.length() / 20, 1, 3)


func damage(amount: float, _reward: int, _burn: float, shooter: VehicleBody) \
		-> int:
	if shield_mode == ShieldModes.ABSORB:
		heal(amount)
		return 0
	if alive:
		return reduce_health(amount, shooter)
	return 0


func reduce_health(amount: float, shooter: VehicleBody) -> int:
	health -= amount
	emit_signal("health_changed", health)
	if health <= 0:
		if shooter != null:
			return kill(5, shooter)
		health = 0
	if controls == null:
		get_node("../StuckTimer").start()
	return 0


func kill(penalty_divisor: int, shooter: VehicleBody) -> int:
	alive = false
	shield_mode = ShieldModes.OFF
	get_node("../RespawnTimer").start()
	apply_central_impulse(transform.basis.y * 900)
	var payout: int = scoreboard_record.score / penalty_divisor
	if payout != 0:
		scoreboard_record.lose(payout)
	acid_duration = 0
	acid_cause = null
	emit_signal("acid_changed", 0.0, 0.0, 0.0)
	if shooter.controls == null:
		$DeathAudio.play()
	else:
		GlobalAudio.play("KillImpact")
	$ExplosionParticles.emitting = true
	$DeathParticles.emitting = true
	get_node("../DeathAnimation").play("death")
	return payout


func reward(amount: int):
	scoreboard_record.reward(amount)
	heal(amount)


func heal(amount: float):
	if alive:
		health = min(health + amount, body_values.base_health)
		emit_signal("health_changed", health)
		acid_duration = 0
		acid_cause = null
		emit_signal("acid_changed", acid_duration * ACID_DAMAGE_PER_TICK,
					health, body_values.base_health)
		if controls == null:
			get_node("../StuckTimer").start()


func try_boost() -> float:
	if Input.is_action_pressed(controls.boost):
		return boost.use(self)
	else:
		boost.set_effects(self, false)
		return 0.0


func pause_looping_audio():
	for n in gameplay_manager.pursuers:
		for audio in n.get_node("LoopingAudio").get_children():
			audio.stream_paused = true


func is_good_target(ray_cast: RayCast):
	var collider: PhysicsBody = ray_cast.get_collider()
	return collider != null and collider.is_in_group("combat_vehicle") and \
			collider.scoreboard_record.score >= 100


func reset_stuck_timer():
	get_node("../StuckTimer").start()


func get_vehicle_name() -> String: #overridden in vehicle-specific scripts
	return ""


func _on_RespawnTimer_timeout():
	alive = true
	health = body_values.base_health
	emit_signal("health_changed", health)
	if controls == null:
		get_node("../StuckTimer").start()
	$DeathParticles.emitting = false
	if controls != null:
		get_viewport().stop()
	get_node("../DeathAnimation").play("RESET")
	gameplay_manager.respawn(self)


func _on_StuckTimer_timeout():
	if alive:
		gameplay_manager.respawn(self)
