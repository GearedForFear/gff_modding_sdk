extends UpdatingCamera


func apply_settings(settings_manager: SettingsManager):
	fov = settings_manager.field_of_view
	.apply_settings(settings_manager)
