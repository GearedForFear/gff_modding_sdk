extends StandardButton


export var language: String = ""


func _pressed():
	GlobalAudio.play("ButtonPressAudio")
	
	if language == "":
		TranslationServer.set_locale(OS.get_locale_language())
	else:
		TranslationServer.set_locale(language)
	var config: ConfigFile = SettingsManager.get_config()
	config.set_value("ui", "language", language)
	config.save("user://config.cfg")
	
	MenuManager.escape()
