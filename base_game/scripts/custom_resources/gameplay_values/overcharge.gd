class_name Overcharge
extends Boost


func prepare(vehicle: VehicleBody):
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		DeletionManager.add_to_garbage(
				vehicle.get_node("OverchargeCPUParticles"))
	else:
		DeletionManager.add_to_garbage(vehicle.get_node("OverchargeParticles"))
		vehicle.get_node("OverchargeCPUParticles").name = "OverchargeParticles"


func use(vehicle: VehicleBody, input: int) -> float:
	if input == Inputs.PRESSED or input == Inputs.JUST_PRESSED:
		vehicle.apply_heat(0.5)
		set_effects(vehicle, true)
		return force
	elif input == Inputs.JUST_RELEASED:
		set_effects(vehicle, false)
	return 0.0


func set_effects(vehicle: VehicleBody, enable: bool):
	vehicle.get_node("LoopingAudio/NitroAudio").stream_paused = not enable
	for n in vehicle.get_node("OverchargeParticles").get_children():
		n.emitting = enable
