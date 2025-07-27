extends Button


export var language: String = ""


func _enter_tree():
	var config: ConfigFile = get_node("/root/RootControl").config
	var setting = config.get_value("ui", "language", "")
	if setting == "":
		setting = OS.get_locale_language()
	TranslationServer.set_locale(setting)


func _pressed():
	var root_control: Control = get_node("/root/RootControl")
	if language == "":
		TranslationServer.set_locale(OS.get_locale_language())
	else:
		TranslationServer.set_locale(language)
	var config: ConfigFile = root_control.config
	config.set_value("ui", "language", language)
	config.save("user://config.cfg")
	get_node("../..").hide()
	get_node("../../../OptionsMenu/Buttons/Language").grab_focus()
	get_node("../../../OptionsMenu").show()
	root_control.get_node("ButtonPressAudio").play()
