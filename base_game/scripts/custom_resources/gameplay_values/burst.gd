class_name Burst
extends Boost


func prepare(vehicle: VehicleBody):
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		DeletionManager.add_to_stack(vehicle.get_node("BurstCPUParticles"))
	else:
		DeletionManager.add_to_stack(vehicle.get_node("BurstParticles"))
		vehicle.get_node("BurstCPUParticles").name = "BurstParticles"


func use(vehicle: VehicleBody) -> float:
	set_effects(vehicle, true)
	return force


func set_effects(vehicle: VehicleBody, enable: bool):
	for n in vehicle.get_node("BurstParticles").get_children():
		n.emitting = enable
