extends Label


func _process(_delta):
	if visible:
		var vsync: bool = OS.vsync_enabled
		var rr: int = OS.get_screen_refresh_rate()
		var standard_frame_rate: bool = rr == 29 or rr == 30 or rr == 59 \
			or rr == 60
		
		var settings_manager: Node = get_node("/root/RootControl/SettingsManager")
		text = "Current Settings:"
		
		text += "\nResolution: " + String(round(OS.window_size.x \
				/ settings_manager.resolution)) + " x " + String(round(\
				OS.window_size.y / settings_manager.resolution))
		
		match settings_manager.msaa:
			0:
				text += "\nNo Anti-Aliasing"
			1:
				text += "\n2x MSAA"
			2:
				text += "\n4x MSAA"
			3:
				text += "\n8x MSAA"
			4:
				text += "\n16x HSAA"
		
		var reflections: int = settings_manager.reflections
		if reflections == 0:
			text += "\nNo Screen-space Reflections"
		else:
			text += "\nReflection Range: " + String(reflections)
			var reflection_cap: int = OS.window_size.x \
					/ settings_manager.resolution / 4
			if reflections > reflection_cap:
				text += " (Capped to " + String(reflection_cap) + ")"
		
		match settings_manager.materials:
			0:
				text += "\nMaterials: Extra Low"
			1:
				text += "\nMaterials: Low"
			2:
				text += "\nMaterials: Default"
		
		match settings_manager.lighting:
			0:
				text += "\nLighting: Extra Low"
			1:
				text += "\nLighting: Low"
			2:
				text += "\nLighting: Default"
		
		if vsync:
			text += "\nVsync On"
		else:
			text += "\nVsync Off"
		
		if settings_manager.mirror_rate_reduced:
			text += "\nRear View Mirror (Multiplayer): Reduced Frame Rate"
		else:
			text += "\nRear View Mirror (Multiplayer): Full Frame Rate"
		
		if settings_manager.transform_interpolation:
			if vsync:
				if standard_frame_rate:
					text += "\nTransform Interpolation: Automatic (Off)"
				else:
					text += "\nTransform Interpolation: Automatic (On)"
			else:
				text += "\nTransform Interpolation: Automatic"
		else:
			text += "\nTransform Interpolation: Always Off"
		
		text += "\nView Distance: " + String(settings_manager.view_distance) \
				+ "m"
		
		text += "\nRear View Distance: " + String(\
				settings_manager.rear_view_distance) + "m"
		
		text += "\nField of View: " + String(settings_manager.field_of_view) \
				+ "°"
		
		match settings_manager.shadow_casters:
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
		
		text += "\nShadow Map Splits: " + String(settings_manager.splits)
		
		text += "\nShadow Map Splits (Multiplayer): " + \
				String(settings_manager.splits_multiplayer)
		
		get_node("/root/RootControl").player_amount = 1
		text += "\nShadow Distance: " + String(round(\
				settings_manager.shadow_distance())) + "m"
		
		var tex_size: String = String(settings_manager.shadow_resolution)
		text += "\nShadow Resolution: " + tex_size + " x " + tex_size
		
		if settings_manager.max_rigid_bodies == 0:
			text += "\nMax Rigid Bodies: Lowest"
		else:
			text += "\nMax Rigid Bodies: " + String(settings_manager\
					.max_rigid_bodies)
		
		text += "\nSound Effects Volume: " + String(round(db2linear(\
				AudioServer.get_bus_volume_db(1)) * 100)) + "%"
		
		text += "\nMusic Volume: " + String(round(db2linear(\
				AudioServer.get_bus_volume_db(2)) * 100)) + "% (coming soon)"
