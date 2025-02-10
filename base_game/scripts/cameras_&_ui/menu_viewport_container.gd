extends ViewportContainer


func _draw():
	var window_scale: Vector2 = OS.window_size / Vector2(640, 320)
	var target_size: Vector2 = min(window_scale.x, window_scale.y) * rect_size \
			/ SettingsManager.get_this().resolution
	target_size.x = max(target_size.x, 4.0)
	target_size.y = max(target_size.y, 4.0)
	$Viewport.size = target_size
