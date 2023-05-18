extends Label


const BASE_FONT_SIZE: float = 9.0


export var menu: bool = false


func _ready():
	var f: DynamicFont = get_font("font")
	f.size = int(BASE_FONT_SIZE * clamp(OS.window_size.y, 0, OS.window_size.x \
			* 9 / 16) / 360 / get_node("/root/RootControl/SettingsManager")\
			.split_screen_divisor)
	
	if f.outline_size != 0:
		f.outline_size = int(clamp(OS.window_size.y, 0, OS.window_size.x * 9 \
				/ 16) / 360 / get_node("/root/RootControl/SettingsManager")\
				.split_screen_divisor)


func update_text(vehicle: VehicleBody):
	text = stat_string(vehicle.base_health / 2)
	text += "\n" + stat_string(vehicle.base_engine_force * 250 / vehicle.weight)
	text += "\n" + stat_string(vehicle.weight / 40)
	text += "\n" + stat_string(vehicle.nitro_force * 25 / vehicle.weight)
	text += "\n" + stat_string(vehicle.rocket_force * 1000 / vehicle.weight)
	text += "\n" + stat_string(vehicle.burst_force * 25 / vehicle.weight)
	text += "\n" + stat_string(0 / vehicle.weight)


func stat_string(stat: float):
	if stat == 0.0:
		return "-"
	return String(round(stat))
