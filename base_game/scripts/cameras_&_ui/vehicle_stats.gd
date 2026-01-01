extends Label


func update_text(vehicle: VehicleBody):
	text = stat_string(vehicle.base_health / 2)
	text += "\n" + stat_string(vehicle.base_engine_force * 250 / vehicle.weight)
	text += "\n" + stat_string(vehicle.weight / 40)
	text += "\n" + stat_string(vehicle.nitro_force * 25 / vehicle.weight)
	text += "\n" + stat_string(vehicle.rocket_force * 1000 / vehicle.weight)
	text += "\n" + stat_string(vehicle.burst_force * 25 / vehicle.weight)
	text += "\n" + stat_string(vehicle.overcharge_force * 25 / vehicle.weight)


func stat_string(stat: float):
	if stat == 0.0:
		return "--"
	return String(round(stat))
