class_name Nitro
extends Boost


func prepare(vehicle: VehicleBody):
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		DeletionManager.add_to_stack(vehicle.get_node("NitroCPUParticles"))
	else:
		DeletionManager.add_to_stack(vehicle.get_node("NitroParticles"))
		vehicle.get_node("NitroCPUParticles").name = "NitroParticles"


func use(vehicle: VehicleBody) -> float:
	if vehicle.get_node("WheelBackLeft").is_in_contact() \
			or vehicle.get_node("WheelBackRight").is_in_contact():
		vehicle.apply_impulse(-vehicle.transform.basis.y * vehicle.weight / 200,
				vehicle.transform.basis.z * 2)
	set_effects(vehicle, true)
	return force


func set_effects(vehicle: VehicleBody, enable: bool):
	vehicle.get_node("LoopingAudio/NitroAudio").stream_paused = not enable
	for n in vehicle.get_node("NitroParticles").get_children():
		n.emitting = enable
