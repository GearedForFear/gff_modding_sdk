extends OmniLight


func _ready():
	var settings_manager: Node = get_node("/root/RootControl/SettingsManager")
	if settings_manager.lighting <= 1:
		hide()
