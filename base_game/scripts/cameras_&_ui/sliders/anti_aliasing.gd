extends HSlider


const LABEL_PATH = "../AntiAliasingLabel"


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = root_control.config.get_value("graphics", "msaa", 0)
	root_control.get_node("SettingsManager").msaa = value


func _on_AntiAliasingSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_AntiAliasingSlider_value_changed(value):
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.msaa = value
	settings_manager.apply_settings()
	config.set_value("graphics", "msaa", value)
	config.save("user://config.cfg")
	root_control.get_node("SliderChangeAudio").play()
	var label: Label = get_node(LABEL_PATH)
	match value:
		0.0:
			label.text = "Anti-Aliasing: Off"
		1.0:
			label.text = "Anti-Aliasing: 2x MSAA"
		2.0:
			label.text = "Anti-Aliasing: 4x MSAA"
		3.0:
			label.text = "Anti-Aliasing: 8x MSAA"
		4.0:
			label.text = "Anti-Aliasing: 16x HSAA"


func _on_AntiAliasingSlider_draw():
	get_node("../../../Info").visible = Resolution.vram_hungry()
