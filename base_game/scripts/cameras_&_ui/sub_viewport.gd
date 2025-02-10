class_name SubViewport
extends Viewport


func _enter_tree():
	var settings_manager: Node = get_node("/root/RootControl/SettingsManager")
	settings_manager.to_update.append(self)
	apply_settings(settings_manager)


func stop():
	render_target_update_mode = UPDATE_DISABLED
	$Timer.start()


func apply_settings(settings_manager: Node):
	msaa = settings_manager.msaa


func _on_Timer_timeout():
	render_target_update_mode = UPDATE_WHEN_VISIBLE
