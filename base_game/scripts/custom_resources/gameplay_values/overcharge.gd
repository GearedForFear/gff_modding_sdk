class_name Overcharge
extends Boost


func prepare(vehicle: VehicleBody):
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		DeletionManager.add_to_stack(vehicle.get_node("OverchargeCPUParticles"))
	else:
		DeletionManager.add_to_stack(vehicle.get_node("OverchargeParticles"))
		vehicle.get_node("OverchargeCPUParticles").name = "OverchargeParticles"


func use(vehicle: VehicleBody) -> float:
	vehicle.apply_heat(0.5)
	set_effects(vehicle, true)
	return force


func set_effects(vehicle: VehicleBody, enable: bool):
	vehicle.get_node("LoopingAudio/NitroAudio").stream_paused = not enable
	for n in vehicle.get_node("OverchargeParticles").get_children():
		n.emitting = enable
