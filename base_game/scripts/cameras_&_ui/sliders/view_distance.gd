extends HSlider


const LABEL_PATH = "../ViewDistanceLabel"
const VALUES := PoolIntArray([100, 200, 300, 400, 500, 750, 1000, 1500, 2500])


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = VALUES.find(root_control.config.get_value(
			"graphics", "view_distance", 2500))
	root_control.get_node("SettingsManager").view_distance = VALUES[value]


func _draw():
	var label: Label = get_node(LABEL_PATH)
	var converted_value: int = VALUES[value]
	label.text = tr("VIEW_DISTANCE") + ": " + String(converted_value) + "m"


func _on_ViewDistanceSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_ViewDistanceSlider_value_changed(value):
	var converted_value: int = VALUES[value]
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.view_distance = converted_value
	settings_manager.apply_settings()
	config.set_value("graphics", "view_distance", converted_value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	_draw()
