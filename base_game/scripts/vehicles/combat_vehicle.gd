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

var steer_target: float = 0.0
var alive: bool = false
var max_drift_left: float = 20.0
var max_drift_right: float = -20.0
var score: int = 0
var placement: int = 1
var target: Spatial
var driver_name: String = "Player"

var controls: PlayerControls # null == cpu controlled
var track: Spatial
var gameplay_manager: Node
var deletion_manager: Node

onready var health: float = base_health
onready var boost_type: int = base_boost_type
onready var animation_player: AnimationPlayer = get_node("../AnimationPlayer")
onready var gles3: bool = OS.get_current_video_driver() == 0


func _enter_tree():
	gameplay_manager = track.get_node("GameplayManager")
	deletion_manager = track.get_node("DeletionManager")
	target = gameplay_manager.get_node("NonPlayerPath/Waypoint0")
	deletion_manager.gameplay_rigid_bodies.append(self)
	get_node("../AnimationPlayer").playback_speed *= \
			ProjectSettings.get_setting("physics/common/physics_fps") / 60
	if controls == null:
		var viewport: Viewport = find_parent("Viewport")
		if viewport != null:
			viewport.render_target_update_mode = Viewport.UPDATE_DISABLED
			viewport.render_target_clear_mode = \
					Viewport.CLEAR_MODE_ONLY_NEXT_FRAME
		deletion_manager.to_be_deleted.append($CameraBase)
	else:
		gameplay_manager.players.append(self)
		match get_parent().get_parent().get_parent().get_parent().name:
			"SpawnPoint1":
				driver_name = "Player 1"
			"SpawnPoint2":
				driver_name = "Player 2"
			"SpawnPoint3":
				driver_name = "Player 3"
			"SpawnPoint4":
				driver_name = "Player 4"
			"SpawnPoint5":
				driver_name = "Player 5"
			"SpawnPoint6":
				driver_name = "Player 6"
	if is_in_group("heist_target"):
		global_transform.origin = track.get_node("TargetStartSpawn")\
				.translation + get_parent().get_parent().translation.rotated(\
				Vector3.UP, track.get_node("TargetStartSpawn").rotation.y)
		rotation = track.get_node("TargetStartSpawn").rotation
	else:
		global_transform.origin = track.get_node("StartSpawns").translation \
				+ get_parent().get_parent().translation.rotated(Vector3.UP, \
				track.get_node("StartSpawns").rotation.y)
		rotation = track.get_node("StartSpawns").rotation
		gameplay_manager.pursuers.append(self)
	reset_physics_interpolation()


func _process(_delta):
	if controls != null and alive:
		var direction: Vector3 = global_transform.origin.direction_to(\
				target.global_transform.origin)
		var arrow: Polygon2D = \
				$CameraBase/Camera/AspectRatioContainer/Control/ArrowBackground/Control/Polygon2D
		arrow.transform.x = Vector2(direction.z, -direction.x).normalized()
		arrow.transform.y = Vector2(direction.x, direction.z).normalized()
		arrow.rotation += $CameraBase/Camera.rotation.y + PI


func _physics_process(_delta):
	if controls != null and Input.is_action_just_released(controls.pause):
		gameplay_manager.get_parent().queue_free()
		get_node("/root/RootControl").active(true)
	
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
			steer_target = Input.get_action_strength(controls.turn_left) \
					- Input.get_action_strength(controls.turn_right)
			brake = 0.0
			
			if Input.is_action_pressed(controls.boost):
				match boost_type:
					boost_types.NITRO:
						acceleration_factor = nitro_force
						if $WheelBackLeft.is_in_contact() or \
								$WheelBackRight.is_in_contact():
							apply_impulse(-transform.basis.y * 2, transform.basis.z * 2)
						
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
			else:
				match boost_type:
					boost_types.NITRO:
						if gles3:
							for n in $NitroParticles.get_children():
								n.emitting = false
						else:
							for n in $NitroCPUParticles.get_children():
								n.emitting = false
					boost_types.ROCKET:
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
			
			if Input.is_action_pressed(controls.reverse):
				if acceleration_factor != 0.0:
					acceleration_factor = -acceleration_factor
				elif transform.basis.xform_inv(linear_velocity).x < -1:
					brake = Input.get_action_strength(controls.reverse)
				else:
					acceleration_factor = -base_engine_force \
							* Input.get_action_strength(controls.reverse)
			elif acceleration_factor == 0.0 \
					and Input.is_action_pressed(controls.accelerate):
				acceleration_factor = base_engine_force \
						* Input.get_action_strength(controls.accelerate)
			
			max_drift_left = clamp(max_drift_left + 0.2, 0, 20)
			max_drift_right = clamp(max_drift_right - 0.2, -20, 0)
			if Input.is_action_pressed(controls.drift) and ($WheelFrontLeft\
					.is_in_contact() or $WheelFrontRight.is_in_contact()):
				var impulse: float = clamp(steering * linear_velocity.length() \
						/ 10, max_drift_right, max_drift_left)
				apply_impulse(transform.basis.z * -0.8, transform.basis.x \
						* impulse * -20)
				max_drift_left = clamp(max_drift_left - impulse, 0, 20)
				max_drift_right = clamp(max_drift_right - impulse, -20, 0)
				
				if gles3:
					for n in $DriftParticles.get_children():
						n.emitting = true
				else:
					for n in $DriftCPUParticles.get_children():
						n.emitting = true
			else:
				if gles3:
					for n in $DriftParticles.get_children():
						n.emitting = false
				else:
					for n in $DriftCPUParticles.get_children():
						n.emitting = false
			
			if Input.is_action_just_pressed(controls.respawn):
				gameplay_manager.respawn(self)
		
		steer_target *= STEER_LIMIT
		steering = move_toward(steering, steer_target, STEER_SPEED)
		
		# Increase engine force at low speeds to make the initial acceleration 
		# faster.
		var speed = linear_velocity.length()
		if speed < 5 and speed != 0:
			engine_force = clamp(acceleration_factor * 5 / speed, \
					-abs(acceleration_factor) * 2, abs(acceleration_factor) * 2)
		else:
			engine_force = acceleration_factor


func damage(amount: float, _reward: int, _burn: float, shooter: VehicleBody) \
		-> int:
	if alive:
		health -= amount
		if health <= 0:
			if shooter == null:
				health = 0
			else:
				alive = false
				get_parent().get_node("RespawnTimer").start()
				apply_central_impulse(transform.basis.y * 170)
				animation_player.play("death")
				var payout: int = score / 5
				score -= payout
				if gles3:
					$DeathParticles.emitting = true
				else:
					$DeathCPUParticles.emitting = true
				return payout
		if controls == null:
			get_node("../StuckTimer").start()
	return 0


func reward(amount: int):
	score += amount
	health = clamp(health + amount, 0.0, base_health)
	if controls == null:
		get_node("../StuckTimer").start()


func _on_RespawnTimer_timeout():
	alive = true
	health = base_health
	if controls == null:
		get_node("../StuckTimer").start()
	if gles3:
		$DeathParticles.emitting = false
	else:
		$DeathCPUParticles.emitting = false
	gameplay_manager.respawn(self)


func _on_StuckTimer_timeout():
	if alive:
		gameplay_manager.respawn(self)
