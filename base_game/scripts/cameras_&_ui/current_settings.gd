extends Label


func _process(_delta):
	text = "Current Settings:"
	
	if OS.window_fullscreen:
		text += "\nFullscreen"
	elif OS.window_borderless:
		text += "\nBorderless Window"
	else:
		text += "\nDefault Window"
	
	text += "\n" + String(round(OS.window_size.x \
			/ get_node("/root/RootControl/SettingsManager").resolution)) + "/" \
			+ String(round(OS.window_size.y \
			/ get_node("/root/RootControl/SettingsManager").resolution))
	
	match get_node("/root/RootControl/SettingsManager").msaa:
		0:
			text += "\nMSAA Off"
		1:
			text += "\n2x MSAA"
		2:
			text += "\n4x MSAA"
		3:
			text += "\n8x MSAA"
		4:
			text += "\n16x MSAA"
	
	if OS.vsync_enabled:
		text += "\nVsync On"
	else:
		text += "\nVsync Off"
	
	text += "\nView Distance: " + String(get_node(\
			"/root/RootControl/SettingsManager").view_distance) + "m"
	
	text += "\nRear View Distance: " + String(get_node(\
			"/root/RootControl/SettingsManager").rear_view_distance) + "m"
	
	text += "\nField of View: " + String(get_node(\
			"/root/RootControl/SettingsManager").field_of_view) + "°"
	
	match get_node("/root/RootControl/SettingsManager").shadow_amount:
		0:
			text += "\nNo Shadows"
		1:
			text += "\nShadow Amount: Extra Low"
		2:
			text += "\nShadow Amount: Low"
		3:
			text += "\nShadow Amount: Default"
		4:
			text += "\nShadow Amount: High"
		5:
			text += "\nShadow Amount: Ultimate"
	
	if get_node("/root/RootControl/SettingsManager").max_rigid_bodies == 0:
		text += "\nMax Rigid Bodies: Lowest"
	else:
		text += "\nMax Rigid Bodies: " + String(\
				get_node("/root/RootControl/SettingsManager").max_rigid_bodies)
