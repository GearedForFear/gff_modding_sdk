class_name Burst
extends Boost


func prepare(vehicle: VehicleBody):
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		DeletionManager.add_to_garbage(vehicle.get_node("BurstCPUParticles"))
	else:
		DeletionManager.add_to_garbage(vehicle.get_node("BurstParticles"))
		vehicle.get_node("BurstCPUParticles").name = "BurstParticles"


func use(vehicle: VehicleBody, input: int) -> float:
	if input == Inputs.JUST_PRESSED:
		vehicle.xp += 6.0
		vehicle.burst_remaining = 6 * vehicle.level
		set_effects(vehicle, true)
		var audio: AudioStreamPlayer3D = vehicle.get_node(
				"LoopingAudio/BurstAudio")
		audio.unit_size = vehicle.level * 0.5
		audio.play()
	
	if vehicle.burst_remaining > 0:
		vehicle.burst_remaining -= 1
		return force
	else:
		set_effects(vehicle, false)
		return 0.0


func set_effects(vehicle: VehicleBody, enable: bool):
	for n in vehicle.get_node("BurstParticles").get_children():
		n.emitting = enable
