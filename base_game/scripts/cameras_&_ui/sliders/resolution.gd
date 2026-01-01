extends SettingsSlider


const LABEL_PATH = "../Label"

var resolutions: Array


func _enter_tree():
	update_resolutions()
	value = find_position(SettingsManager.get_config().get_value(\
			"graphics", "resolution", 1))
	SettingsManager.get_this().resolution = resolutions[value]
	update_label()


func find_position(var resolution_divisor) -> int:
	var return_value: int
	for n in 1000:
		return_value = resolutions.find(resolution_divisor + n)
		if return_value != -1:
			break
		return_value = resolutions.find(resolution_divisor - n)
		if return_value != -1:
			break
	return_value -= resolutions.size()
	return return_value


func update_all():
	update_resolutions()
	update_label()


func update_resolutions():
	var existing_resolutions := Array()
	resolutions.clear()
	var n: int = 1
	while true:
		var new_resolution: Vector2 = to_resolution(n)
		if not existing_resolutions.has(new_resolution):
			existing_resolutions.append(new_resolution)
			resolutions.append(n)
			if new_resolution == Vector2(4.0, 4.0):
				break
		n += 1
	resolutions.invert()
	min_value = -resolutions.size()


func update_label():
	var label: Label = get_node(LABEL_PATH)
	var resolution: Vector2 = to_resolution(resolutions[value])
	label.text = tr("RESOLUTION") + ": " \
			+ String(resolution.x) + " x " + String(resolution.y)


func to_resolution(var divisor: int) -> Vector2:
	var return_value: Vector2 = OS.window_size / divisor
	return_value.x = max(int(return_value.x), 4.0)
	return_value.y = max(int(return_value.y), 4.0)
	return return_value


func _on_HSlider_value_changed(value):
	SettingsManager.get_this().resolution = resolutions[value]
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("graphics", "resolution", resolutions[value])
	config.save("user://config.cfg")
	get_node("../../ViewportContainer")._draw()
	update_setting()
	update_all()


func _on_ViewportContainer_draw():
	update_all()
