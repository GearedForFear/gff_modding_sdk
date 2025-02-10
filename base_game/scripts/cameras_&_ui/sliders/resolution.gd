class_name Resolution
extends HSlider


const LABEL_PATH = "../Label"

var resolutions: Array


func _enter_tree():
	update_resolutions()
	var root_control: Control = get_node("/root/RootControl")
	value = find_position(root_control.config.get_value(\
			"graphics", "resolution", 1))
	root_control.get_node("SettingsManager").resolution = resolutions[value]


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
	get_node("../../Warning").visible = vram_hungry()


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
	label.text = "Resolution: " \
			+ String(resolution.x) + " x " + String(resolution.y)


func to_resolution(var divisor: int) -> Vector2:
	var return_value: Vector2 = OS.window_size / divisor
	return_value.x = max(int(return_value.x), 4.0)
	return_value.y = max(int(return_value.y), 4.0)
	return return_value


static func vram_hungry() -> bool:
	var settings_manager: SettingsManager = SettingsManager.get_this()
	var resolution: Vector2 = OS.window_size / settings_manager.resolution
	var pixels: int = resolution.x * resolution.y
	match settings_manager.msaa:
		VisualServer.VIEWPORT_MSAA_4X:
			return pixels > 11_000_000
		VisualServer.VIEWPORT_MSAA_8X:
			return pixels > 6_000_000
		VisualServer.VIEWPORT_MSAA_16X:
			return pixels > 3_000_000
	return false


func _on_AntiAliasingSlider_value_changed(value):
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: SettingsManager = root_control.get_node(\
			"SettingsManager")
	settings_manager.resolution = resolutions[value]
	Reflections.update_reflections()
	var config: ConfigFile = root_control.config
	config.set_value("graphics", "resolution", resolutions[value])
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	get_node("../../ViewportContainer")._draw()
	update_all()


func _on_ViewportContainer_draw():
	update_all()
