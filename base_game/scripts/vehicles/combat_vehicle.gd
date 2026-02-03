class_name CombatVehicle
extends VehicleBody


signal health_changed(new)
signal acid_changed(new, health, base_health)

const STEER_SPEED: float = 0.03
const STEER_LIMIT: float = 0.4
const ACID_DAMAGE_PER_TICK: float = 0.1

export var master_body: bool = true
export var body_values: Resource

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

onready var health: float = body_values.base_health
onready var boost: Boost = body_values.boost
onready var gles3: bool = OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3


func _enter_tree():
	weight = body_values.weight
	gameplay_manager = track.get_node("GameplayManager")
	pools = track.get_node("Pools")
	target = gameplay_manager.get_node("NonPlayerPath/Waypoint0")
	if master_body:
		if controls == null:
			var viewport: Viewport = find_parent("Viewport")
			if viewport != null:
				viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
				viewport.render_target_clear_mode = \
						Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
			DeletionManager.add_to_stack($CameraBase)
		else:
			DeletionManager.add_to_stack(get_node("../StuckTimer"))
		
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
				DeletionManager.add_to_stack($ExplosionCPUParticles)
				DeletionManager.add_to_stack($DeathCPUParticles)
				DeletionManager.add_to_stack($DriftCPUParticles)
				DeletionManager.add_to_stack($AcidCPUParticles)
			else:
				DeletionManager.add_to_stack($ExplosionParticles)
				DeletionManager.add_to_stack($DeathParticles)
				DeletionManager.add_to_stack($DriftParticles)
				DeletionManager.add_to_stack($AcidParticles)
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
			damage(ACID_DAMAGE_PER_TICK, 0, 0.0, acid_cause)
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
	if alive:
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
	if alive:
		health = clamp(health + amount, 0.0, body_values.base_health)
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


func get_vehicle_name() -> String: #overridden in vehicle-specific scripts
	return ""


func random_skin(var body_path: String, var wheels_path: String) -> String:
	var r: int = randi() % 200
	if r < 26:
		return "stock.material"
	var path_ending: String
	if (r < 52):
		path_ending = "demon"
	elif (r < 78):
		path_ending = "greed"
	elif (r < 104):
		path_ending = "skydive"
	elif (r < 130):
		path_ending = "galaxy"
	elif (r < 144):
		path_ending = "flame"
	elif (r < 158):
		path_ending = "y2k"
	elif (r < 172):
		path_ending = "sunset"
	elif (r < 186):
		path_ending = "intense"
	elif (r < 194):
		path_ending = "pearl"
	elif (r < 199):
		path_ending = "glow"
	else:
		path_ending = "gold"
	path_ending += ".material"
	
	var body: MeshInstance = $BodyMesh
	if body_path != "":
		body.set_surface_material(0, ResourceLoader.load(
				body_path + path_ending, "ShaderMaterial"))
	if wheels_path != "":
		var material: ShaderMaterial
		if path_ending == "flame.material":
			var yellow: Color = Color("ffd600")
			body.get_node("WheelFrontLeft").get_active_material(0)\
					.set_shader_param("paint_color", yellow)
			material = ResourceLoader.load(wheels_path +
					"back/stock.material", "ShaderMaterial")
			body.get_node("WheelBackLeft").set_surface_material(0, material)
			body.get_node("WheelBackRight").set_surface_material(0, material)
			var red: Color = Color("ff1800")
			body.get_node("WheelBackLeft").get_active_material(0)\
					.set_shader_param("paint_color", red)
		else:
			material = ResourceLoader.load(wheels_path + "front/" + path_ending,
					"ShaderMaterial")
			body.get_node("WheelFrontLeft").set_surface_material(0, material)
			body.get_node("WheelFrontRight").set_surface_material(0, material)
			material = ResourceLoader.load(wheels_path + "back/" + path_ending,
					"ShaderMaterial")
			body.get_node("WheelBackLeft").set_surface_material(0, material)
			body.get_node("WheelBackRight").set_surface_material(0, material)
	return path_ending


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
