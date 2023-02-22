extends Button


func _pressed():
	OS.vsync_enabled = !OS.vsync_enabled
	get_node("/root/RootControl/ButtonPressAudio").play()
