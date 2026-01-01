class_name UpdatingCamera
extends Camera


func _ready():
	var settings_manager: SettingsManager = SettingsManager.get_this()
	settings_manager.to_update.append(self)
	apply_settings(settings_manager)


func apply_settings(settings_manager: SettingsManager):
	far = settings_manager.view_distance
