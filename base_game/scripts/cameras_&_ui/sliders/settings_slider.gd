class_name SettingsSlider
extends HSlider


enum ActionOnChange {NONE, COMPILE, UPDATE_MATERIALS_AND_COMPILE}

export(ActionOnChange) var on_change


func update_setting():
	GlobalAudio.play("SliderChangeAudio")
	SettingsManager.apply_settings()
	update_label()
	match on_change:
		ActionOnChange.COMPILE:
			MaterialManager.compile_shaders()
		ActionOnChange.UPDATE_MATERIALS_AND_COMPILE:
			MaterialManager.compile_shaders()


func update_label():
	printerr("Override of update_label() expected in "
			+ get_script().resource_path)


func ensure_label_visible(label_path: String):
	get_node("../..").ensure_control_visible(get_node(label_path))
