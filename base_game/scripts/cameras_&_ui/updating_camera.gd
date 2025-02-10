class_name UpdatingCamera
extends Camera


func _enter_tree():
	var settings_manager: Node = get_node("/root/RootControl/SettingsManager")
	settings_manager.to_update.append(self)
	apply_settings(settings_manager)


func apply_settings(settings_manager: SettingsManager):
	far = settings_manager.view_distance
