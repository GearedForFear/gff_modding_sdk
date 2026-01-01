class_name SubViewport
extends Viewport


func _ready():
	SettingsManager.get_this().to_update.append(self)


func stop():
	render_target_update_mode = UPDATE_DISABLED
	$Timer.start()


func apply_settings(settings_manager: Node):
	msaa = settings_manager.msaa


func _on_Timer_timeout():
	render_target_update_mode = UPDATE_WHEN_VISIBLE
