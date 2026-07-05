class_name Rocket
extends Boost


func prepare(vehicle: VehicleBody):
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		DeletionManager.add_array_to_garbage(\
				[vehicle.get_node("RocketCPUParticles"),
				vehicle.get_node("ReverseRocketCPUParticles")])
	else:
		DeletionManager.add_array_to_garbage(\
				[vehicle.get_node("RocketParticles"),
				vehicle.get_node("ReverseRocketParticles")])
		vehicle.get_node("RocketCPUParticles").name = "RocketParticles"
		vehicle.get_node("ReverseRocketCPUParticles").name \
				= "ReverseRocketParticles"


func use(vehicle: VehicleBody) -> float:
	if Input.is_action_pressed(vehicle.controls.reverse):
		vehicle.apply_central_impulse(vehicle.transform.basis.z * -force)
		set_effects_forwards(vehicle, false)
		set_effects_reverse(vehicle, true)
		set_haze_emitting(vehicle.get_node("ReverseHazeParticles"), false)
	else:
		vehicle.apply_central_impulse(vehicle.transform.basis.z * force)
		set_effects_forwards(vehicle, true)
		set_effects_reverse(vehicle, false)
		set_haze_emitting(vehicle.get_node("HazeParticles"), false)
	return vehicle.body_values.base_engine_force


func set_effects(vehicle: VehicleBody, enable: bool):
	set_effects_forwards(vehicle, enable)
	set_effects_reverse(vehicle, enable)


func set_effects_forwards(vehicle: VehicleBody, enable: bool):
	vehicle.get_node("LoopingAudio/RocketAudio").stream_paused = not enable
	for n in vehicle.get_node("RocketParticles").get_children():
		n.emitting = enable


func set_effects_reverse(vehicle: VehicleBody, enable: bool):
	vehicle.get_node("LoopingAudio/ReverseRocketAudio").stream_paused = \
			not enable
	for n in vehicle.get_node("ReverseRocketParticles").get_children():
		n.emitting = enable


func try_haze(vehicle: VehicleBody):
	if Input.is_action_pressed(vehicle.controls.reverse):
		set_haze_emitting(vehicle.get_node("ReverseHazeParticles"), true)
		vehicle.get_node("ReverseHazeTimer").start()
	else:
		set_haze_emitting(vehicle.get_node("HazeParticles"), true)
		vehicle.get_node("HazeTimer").start()


func set_haze_emitting(haze: Spatial, enable: bool):
	for n in haze.get_children():
		n.emitting = enable
