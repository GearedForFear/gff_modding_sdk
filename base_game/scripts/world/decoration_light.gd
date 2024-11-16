extends SpotLight


func _ready():
	var settings_manager: Node = get_node("/root/RootControl/SettingsManager")
	if settings_manager.lighting == 0:
		hide()
		get_node("/root/RootControl/DeletionManager").to_be_deleted.append(self)
