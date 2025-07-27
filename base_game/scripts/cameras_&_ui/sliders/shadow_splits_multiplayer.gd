extends HSlider


const LABEL_PATH = "../ShadowSplitsMultiplayerLabel"


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = root_control.config.get_value("graphics", "splits_multiplayer", 2)
	root_control.get_node("SettingsManager").splits_multiplayer = value


func _draw():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("SHADOW_SPLITS_MP") + ": " + String(value)


func _on_ShadowSplitsMultiplayerSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_ShadowSplitsMultiplayerSlider_value_changed(value):
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.splits_multiplayer = value
	settings_manager.apply_settings()
	config.set_value("graphics", "splits_multiplayer", value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	_draw()
