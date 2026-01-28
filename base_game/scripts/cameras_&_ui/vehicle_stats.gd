extends Label


func update_text(vehicle: VehicleBody):
	text = stat_to_string(vehicle.base_health / 2)
	text += "\n" + stat_to_string(vehicle.base_engine_force * 250 / vehicle.weight)
	text += "\n" + stat_to_string(vehicle.weight / 40)
	
	var boosts: Dictionary = {"Nitro": "--", "Rocket": "--", "Burst": "--",
			"Overcharge": "--"}
	add_boost(vehicle.body_values.boost, vehicle.weight, boosts)
	add_boost(vehicle.second_boost, vehicle.weight, boosts)
	text += "\n" + boosts.Nitro
	text += "\n" + boosts.Rocket
	text += "\n" + boosts.Burst
	text += "\n" + boosts.Overcharge


func stat_to_string(stat: float):
	if stat == 0.0:
		return "--"
	return String(round(stat))


func add_boost(boost: Boost, weight: float, add_to_this: Dictionary):
	if boost == null:
		return
	var key: String
	var value: float
	match boost.get_script().resource_path:
		"res://scripts/custom_resources/nitro.gd":
			key = "Nitro"
			value = boost.force * 25 / weight
		"res://scripts/custom_resources/rocket.gd":
			key = "Rocket"
			value = boost.force * 1000 / weight
		"res://scripts/custom_resources/burst.gd":
			key = "Burst"
			value = boost.force / 40 / weight
		"res://scripts/custom_resources/overcharge.gd":
			key = "Overcharge"
			value = boost.force * 25 / weight
		_:
			assert(false)
	add_to_this[key] = stat_to_string(value)
