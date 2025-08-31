extends HSlider


const LABEL_PATH = "../ShadowCastersLabel"


func _enter_tree():
	var root_control: Control = get_node("/root/RootControl")
	value = root_control.config.get_value("graphics", "shadow_casters", 2)
	root_control.get_node("SettingsManager").shadow_casters = value


func _draw():
	var label: Label = get_node(LABEL_PATH)
	label.text = tr("SHADOW_CASTERS") + ": "
	match value:
		0.0:
			label.text += tr("LOW_2")
		1.0:
			label.text += tr("LOW")
		2.0:
			label.text += tr("DEFAULT")
		3.0:
			label.text += tr("HIGH")
		4.0:
			label.text += tr("HIGH_2")
		5.0:
			label.text += tr("HIGHEST")


func update_shadow_setters(node: Node):
	for n in node.get_children():
		update_shadow_setters(n)
	if node.get_class() == "ShadowSetter":
		node._ready()


func _on_ShadowCastersSlider_focus_entered():
	get_node("../..").ensure_control_visible(get_node(LABEL_PATH))


func _on_ShadowCastersSlider_value_changed(value):
	var root_control: Control = get_node("/root/RootControl")
	var settings_manager: Node = root_control.get_node("SettingsManager")
	var config: ConfigFile = root_control.config
	settings_manager.shadow_casters = value
	settings_manager.apply_settings()
	config.set_value("graphics", "shadow_casters", value)
	config.save("user://config.cfg")
	update_shadow_setters(root_control)
	root_control.get_node("SliderChangeAudio").play()
	_draw()
