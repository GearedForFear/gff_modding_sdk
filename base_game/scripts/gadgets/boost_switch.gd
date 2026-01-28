extends Spatial


export var second_boost: Resource


func use(vehicle: CombatVehicle):
	vehicle.boost.set_effects(vehicle, false)
	if vehicle.boost == second_boost:
		vehicle.boost = vehicle.body_values.boost
		get_node("../../AnimationPlayer").play("rocket_nitro")
		$CloseAudio.play()
		get_node("../LoopingAudio/RocketAudio").stream_paused = true
		get_node("../LoopingAudio/ReverseRocketAudio").stream_paused = true
	else:
		vehicle.boost = second_boost
		$OpenAudio.play()
		get_node("../../AnimationPlayer").play("nitro_rocket")
		get_node("../LoopingAudio/NitroAudio").stream_paused = true
