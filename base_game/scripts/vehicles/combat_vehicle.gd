class_name CombatVehicle
extends VehicleBody


const STEER_SPEED: float = 0.03
const STEER_LIMIT: float = 0.4

enum boost_types {NITRO, ROCKET, NONE, BURST, OVERCHARGE, NITRO_OVERCHARGE}

export var base_health: float = 100.0
export var base_engine_force: float = 40.0
export(boost_types) var base_boost_type: int = boost_types.NITRO
export var nitro_force: float = 400.0
export var rocket_force: float = 15.0
export var burst_force: float = 400.0
export var overcharge_force: float = 400.0
export var master_body: bool = true
export var scene_resource: String = "res://scenes/vehicles/.tscn"

var steer_target: float = 0.0
var alive: bool = false
var max_drift_left: float = 20.0
var max_drift_right: float = -20.0
var burst_duration: int = 0
var acid_duration: int = 0
var acid_cause: CombatVehicle
var scoreboard_record: ScoreboardRecord
var target: Spatial
var controls: PlayerControls # null == cpu controlled
var replacement: CombatVehicle
var track: Spatial
var gameplay_manager: Node
var pools: Node

onready var health: float = base_health
onready var boost_type: int = base_boost_type
onready var gles3: bool = OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3


func _enter_tree():
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
			get_node("/root/RootControl/DeletionManager").to_be_deleted.append(\
					$CameraBase)
		else:
			get_node("/root/RootControl/DeletionManager").to_be_deleted.append(\
					get_node("../StuckTimer"))
		if not is_in_group("heist_target"):
			global_transform.origin = track.get_node("StartSpawns").translation \
					+ get_node("../..").translation.rotated(Vector3.UP, \
					track.get_node("StartSpawns").rotation.y)
			rotation = track.get_node("StartSpawns").rotation
			gameplay_manager.pursuers.append(self)
		reset_physics_interpolation()


func _physics_process(_delta):
	if master_body and controls != null \
			and Input.is_action_just_pressed(controls.pause):
		$CameraBase/Camera/AspectRatioContainer/Control/Pause.open(true)
		get_tree().paused = true
	
	if alive:
		var acceleration_factor: float = 0.0
		
		if controls == null and target != null:
			var direction: Vector3 = global_transform.origin.direction_to(\
					target.global_transform.origin).rotated(Vector3.UP, \
					-rotation.y)
			steer_target = direction.x
			if direction.z < 0: # If the target is behind this vehicle:
				steer_target = clamp(steer_target * 1000, -1, 1)
			else:
				steer_target = clamp(steer_target, -1, 1)
			acceleration_factor = base_engine_force
		else:
			steer_target = Input.get_action_strength(controls.turn_left_strength) \
					- Input.get_action_strength(controls.turn_right_strength)
			brake = 0.0
			
			if Input.is_action_pressed(controls.boost):
				match boost_type:
					boost_types.NITRO:
						acceleration_factor = nitro_force
						if $WheelBackLeft.is_in_contact() or \
								$WheelBackRight.is_in_contact():
							apply_impulse(-transform.basis.y * weight / 200, \
									transform.basis.z * 2)
						$LoopingAudio/NitroAudio.stream_paused = false
						if gles3:
							for n in $NitroParticles.get_children():
								n.emitting = true
						else:
							for n in $NitroCPUParticles.get_children():
								n.emitting = true
					boost_types.ROCKET:
						if Input.is_action_pressed(controls.reverse):
							apply_central_impulse(transform.basis.z \
									* -rocket_force)
							$LoopingAudio/RocketAudio.stream_paused = true
							$LoopingAudio/ReverseRocketAudio.stream_paused = false
							if gles3:
								for n in $ReverseRocketParticles.get_children():
									n.emitting = true
								for n in $RocketParticles.get_children():
									n.emitting = false
							else:
								for n in $ReverseRocketCPUParticles.get_children():
									n.emitting = true
								for n in $RocketCPUParticles.get_children():
									n.emitting = false
						else:
							apply_central_impulse(transform.basis.z \
									* rocket_force)
							$LoopingAudio/RocketAudio.stream_paused = false
							$LoopingAudio/ReverseRocketAudio.stream_paused = true
							if gles3:
								for n in $RocketParticles.get_children():
									n.emitting = true
								for n in $ReverseRocketParticles.get_children():
									n.emitting = false
							else:
								for n in $RocketCPUParticles.get_children():
									n.emitting = true
								for n in $ReverseRocketCPUParticles.get_children():
									n.emitting = false
						acceleration_factor = base_engine_force
					boost_types.OVERCHARGE:
						change_heat(0.5)
						acceleration_factor = overcharge_force
						$LoopingAudio/NitroAudio.stream_paused = false
						if gles3:
							for n in $OverchargeParticles.get_children():
								n.emitting = true
						else:
							for n in $OverchargeCPUParticles.get_children():
								n.emitting = true
			else:
				match boost_type:
					boost_types.NITRO:
						$LoopingAudio/NitroAudio.stream_paused = true
						if gles3:
							for n in $NitroParticles.get_children():
								n.emitting = false
						else:
							for n in $NitroCPUParticles.get_children():
								n.emitting = false
					boost_types.ROCKET:
						$LoopingAudio/RocketAudio.stream_paused = true
						$LoopingAudio/ReverseRocketAudio.stream_paused = true
						if gles3:
							for n in $RocketParticles.get_children():
								n.emitting = false
							for n in $ReverseRocketParticles.get_children():
								n.emitting = false
						else:
							for n in $RocketCPUParticles.get_children():
								n.emitting = false
							for n in $ReverseRocketCPUParticles.get_children():
								n.emitting = false
					boost_types.OVERCHARGE:
						$LoopingAudio/NitroAudio.stream_paused = true
						if gles3:
							for n in $OverchargeParticles.get_children():
								n.emitting = false
						else:
							for n in $OverchargeCPUParticles.get_children():
								n.emitting = false
			
			if Input.is_action_just_pressed(controls.boost) \
					and boost_type == boost_types.BURST:
				var lv: int = burst()
				burst_duration = 6 * lv
				$LoopingAudio/BurstAudio.unit_size = lv * 0.5
				$LoopingAudio/BurstAudio.play()
			if burst_duration > 0:
				burst_duration -= 1
				acceleration_factor = burst_force * 1000
				if gles3:
					for n in $BurstParticles.get_children():
						n.emitting = true
				else:
					for n in $BurstCPUParticles.get_children():
						n.emitting = true
			elif boost_type == boost_types.BURST:
				if gles3:
					for n in $BurstParticles.get_children():
						n.emitting = false
				else:
					for n in $BurstCPUParticles.get_children():
						n.emitting = false
			
			if Input.is_action_pressed(controls.reverse):
				if acceleration_factor != 0.0:
					acceleration_factor = -acceleration_factor
				elif transform.basis.xform_inv(linear_velocity).x < -1:
					brake = Input.get_action_strength(controls.reverse)
				else:
					acceleration_factor = -base_engine_force \
							* Input.get_action_strength(\
							controls.reverse)
			elif acceleration_factor == 0.0:
				acceleration_factor = base_engine_force \
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
				if gles3:
					for n in $DriftParticles.get_children():
						n.emitting = true
				else:
					for n in $DriftCPUParticles.get_children():
						n.emitting = true
			else:
				$LoopingAudio/DriftAudio.stream_paused = true
				if gles3:
					for n in $DriftParticles.get_children():
						n.emitting = false
				else:
					for n in $DriftCPUParticles.get_children():
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
			damage(0.1, 0, 0.0, acid_cause)
			acid_duration -= 1
			if gles3:
				for n in $AcidParticles.get_children():
					n.emitting = true
			else:
				for n in $AcidCPUParticles.get_children():
					n.emitting = true
		else:
			if gles3:
				for n in $AcidParticles.get_children():
					n.emitting = false
			else:
				for n in $AcidCPUParticles.get_children():
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


func damage(amount: float, _reward: int, burn: float, shooter: VehicleBody) \
		-> int:
	if alive:
		health -= amount
		change_heat(burn)
		if health <= 0:
			if shooter == null:
				health = 0
			else:
				alive = false
				get_node("../RespawnTimer").start()
				apply_central_impulse(transform.basis.y * 900)
				var payout: int = scoreboard_record.score / 5
				if payout != 0:
					scoreboard_record.lose(payout)
				acid_duration = 0
				acid_cause = null
				if gles3:
					$ExplosionParticles.emitting = true
					$DeathParticles.emitting = true
				else:
					$ExplosionCPUParticles.emitting = true
					$DeathCPUParticles.emitting = true
				return payout
		if controls == null:
			get_node("../StuckTimer").start()
	return 0


func reward(amount: int):
	scoreboard_record.reward(amount)
	if alive:
		health = clamp(health + amount, 0.0, base_health)
		change_heat(-amount)
		acid_duration = 0
		acid_cause = null
		if controls == null:
			get_node("../StuckTimer").start()


func burst() -> int: #overridden in level_vehicle.gd
	return 0


func change_heat(var _amount: float): #overridden in heat_vehicle.gd
	pass


func remove_heat(): #overridden in heat_vehicle.gd
	pass


func pause_looping_audio():
	for n in gameplay_manager.pursuers:
		for audio in n.get_node("LoopingAudio").get_children():
			audio.stream_paused = true


func delete(node: Node):
	get_node("/root/RootControl/DeletionManager").to_be_deleted.append(node)


func get_vehicle_name() -> String: #overridden in vehicle-specific scripts
	return ""


func random_skin(var body_path: String, var wheels_path: String):
	var r: int = randi() % 200
	if r < 26:
		return
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
	body.material_override = ResourceLoader.load(body_path + path_ending,
			"ShaderMaterial")
	if wheels_path != "":
		var material: ShaderMaterial
		if path_ending == "flame.material":
			var yellow: Color = Color("ffd600")
			body.get_node("WheelFrontLeft").get_active_material(0)\
					.set_shader_param("paint_color", yellow)
			material = ResourceLoader.load(wheels_path +
					"stock_duplicate.material", "ShaderMaterial")
			body.get_node("WheelBackLeft").material_override = material
			body.get_node("WheelBackRight").material_override = material
		else:
			material = ResourceLoader.load(wheels_path + path_ending,
					"ShaderMaterial")
			body.get_node("WheelFrontLeft").material_override = material
			body.get_node("WheelFrontRight").material_override = material
			body.get_node("WheelBackLeft").material_override = material
			body.get_node("WheelBackRight").material_override = material


func _on_RespawnTimer_timeout():
	alive = true
	health = base_health
	remove_heat()
	if controls == null:
		get_node("../StuckTimer").start()
	if gles3:
		$DeathParticles.emitting = false
	else:
		$DeathCPUParticles.emitting = false
	if controls != null:
		get_viewport().stop()
	gameplay_manager.respawn(self)


func _on_StuckTimer_timeout():
	if alive:
		gameplay_manager.respawn(self)
