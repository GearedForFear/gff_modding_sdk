class_name SubViewport
extends Viewport


func _ready():
	msaa = get_node("/root/RootControl/SettingsManager").msaa


func stop():
	render_target_update_mode = UPDATE_DISABLED
	$Timer.start()


func _on_Timer_timeout():
	render_target_update_mode = UPDATE_WHEN_VISIBLE
