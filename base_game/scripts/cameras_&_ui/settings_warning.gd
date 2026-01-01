extends Label


export var advanced := false


func _enter_tree():
	update_warning()


func update_warning():
	var warnings := []
	if vram_hungry():
		warnings.append(tr("NEED_MORE_VRAM"))
	if cpu_demanding() and advanced:
		warnings.append(tr("MANY_RIGID_BODIES"))
	
	text = ""
	for n in warnings.size():
		if n != 0:
			text += "\n\n"
		text += warnings[n]
	
	visible = not warnings.empty()


func vram_hungry() -> bool:
	var settings_manager: SettingsManager = SettingsManager.get_this()
	var resolution: Vector2 = OS.window_size / settings_manager.resolution
	var pixels: int = resolution.x * resolution.y
	match settings_manager.msaa:
		VisualServer.VIEWPORT_MSAA_4X:
			return pixels > 11_000_000
		VisualServer.VIEWPORT_MSAA_8X:
			return pixels > 6_000_000
		VisualServer.VIEWPORT_MSAA_16X:
			return pixels > 3_000_000
	return false


func cpu_demanding() -> bool:
	return SettingsManager.get_this().max_rigid_bodies > 1000


func _on_HSlider_value_changed(_value):
	update_warning()


func _on_AntiAliasingSlider_value_changed(_value):
	update_warning()


func _on_ShadowResolutionSlider_value_changed(_value):
	update_warning()


func _on_MaximumRigidBodiesSlider_value_changed(_value):
	update_warning()
