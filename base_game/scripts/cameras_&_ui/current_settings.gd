extends Label


func _process(_delta):
	if visible:
		text = "Current Settings:"
		
		if OS.window_fullscreen:
			text += "\nFullscreen"
		elif OS.window_borderless:
			text += "\nBorderless Window"
		else:
			text += "\nDefault Window"
		
		text += "\n" + String(round(OS.window_size.x \
				/ get_node("/root/RootControl/SettingsManager").resolution)) \
				+ " x " + String(round(OS.window_size.y \
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
		
		match get_node("/root/RootControl/SettingsManager").shadow_casters:
			0:
				text += "\nNo Shadows"
			1:
				text += "\nShadow Casters: Extra Low"
			2:
				text += "\nShadow Casters: Low"
			3:
				text += "\nShadow Casters: Default"
			4:
				text += "\nShadow Casters: High"
			5:
				text += "\nShadow Casters: Extra High"
			6:
				text += "\nShadow Casters: Ultimate"
		
		text += "\nShadow Distance: " + String(get_node(\
				"/root/RootControl/SettingsManager").shadow_distance) + "m"
		
		if get_node("/root/RootControl/SettingsManager").max_rigid_bodies == 0:
			text += "\nMax Rigid Bodies: Lowest"
		else:
			text += "\nMax Rigid Bodies: " + String(\
					get_node("/root/RootControl/SettingsManager").max_rigid_bodies)
		
		text += "\n\nSound Effects Volume: " + String(round(db2linear(\
				AudioServer.get_bus_volume_db(1)) * 100)) + "%"
		
		text += "\nMusic Volume: " + String(round(db2linear(\
				AudioServer.get_bus_volume_db(2)) * 100)) + "% (coming soon)"
