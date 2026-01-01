class_name LoadingManager
extends Node


signal resources_loaded

var loading_finished: bool = false


func _process(_delta):
	if loading_finished:
		var container: AspectRatioContainer = get_node_or_null(
				"../AspectRatioContainer")
		if container == null:
			container = get_parent().menu_orphans[0]
		var main_menu: Control = container.get_node("MainMenu")
		var viewports: PackedScene = ResourceLoader.load(
				"res://scenes/cameras_&_ui/main_menu_viewports.tscn",
				"PackedScene")
		
		main_menu.add_child(viewports.instance())
		get_node("../DeletionManager").to_be_deleted.append(
				get_node("../AspectRatioContainer/MainMenu/Images"))
		
		var nodes_to_replace_iceland := Array()
		var nodes_to_replace_usa := Array()
		
		var map_parent: Node = container.get_node("TrackMenu/SelectedView/Viewport")
		nodes_to_replace_iceland.append(map_parent.get_node("Iceland"))
		nodes_to_replace_usa.append(map_parent.get_node("USA"))
		map_parent = container.get_node("TrackMenu/SmallViewports")
		nodes_to_replace_usa.append(map_parent.get_node(
				"TheCalmView/Viewport/Map"))
		nodes_to_replace_iceland.append(map_parent.get_node(
				"BelowView/Viewport/Map"))
		nodes_to_replace_usa.append(map_parent.get_node(
				"TwistedView/Viewport/Map"))
		map_parent = container
		nodes_to_replace_usa.append(map_parent.get_node(
				"OptionsMenu/ViewportContainer/Viewport/Map"))
		nodes_to_replace_iceland.append(map_parent.get_node(
				"WindowModeMenu/ViewportContainer/Viewport/Map"))
		nodes_to_replace_usa.append(map_parent.get_node(
				"LanguageMenu/ViewportContainer/Viewport/Map"))
		nodes_to_replace_iceland.append(map_parent.get_node(
				"SoundMenu/ViewportContainer/Viewport/Map"))
		nodes_to_replace_iceland.append(map_parent.get_node(
				"AdvancedMenu/ViewportContainer/Viewport/Map"))
		
		var resolution_map: Spatial = get_node_or_null(
				"../ResolutionMenu/ViewportContainer/Viewport/Map")
		if resolution_map == null:
			resolution_map = get_parent().menu_orphans[1].get_node(
				"ViewportContainer/Viewport/Map")
		nodes_to_replace_usa.append(resolution_map)
		
		var fov_map: Spatial = get_node_or_null(
				"../FOVMenu/ViewportContainer/Viewport/Map")
		if fov_map == null:
			fov_map = get_parent().menu_orphans[2].get_node(
				"ViewportContainer/Viewport/Map")
		nodes_to_replace_usa.append(fov_map)
		
		var iceland: PackedScene = ResourceLoader.load(
				"res://scenes/world/maps/iceland.tscn", "PackedScene")
		for n in nodes_to_replace_iceland:
			replace(n, iceland.instance())
		
		var usa: PackedScene = ResourceLoader.load(
				"res://scenes/world/maps/usa.tscn", "PackedScene")
		for n in nodes_to_replace_usa:
			replace(n, usa.instance())
		
		yield(get_tree(), "idle_frame")
		main_menu.get_node("Viewports").show()
		get_node("../Precompiler").can_finish = true
		emit_signal("resources_loaded")
		set_process(false)


# Unused
#static func get_this() -> LoadingManager:
#	return Global.root_control.get_node("LoadingManager") as LoadingManager


func prepare() -> Array:
	SettingsManager.get_this().start()
	var root_control: Control = get_parent()
	Precompiler.get_this().add_materials()
	ResourceManager.get_this().load_resources()
	MaterialManager.get_this().update_settings()
	
	var menu_hierarchy: Node = ResourceLoader.load(
			"res://scenes/cameras_&_ui/menus/menu_hierarchy.tscn",
			"PackedScene").instance()
	menu_hierarchy.propagate_call("instantiate_scene")
	menu_hierarchy.propagate_call("instantiate_scene")
	
	var previous_menu: Control = root_control.get_node("Current")
	root_control.remove_child(previous_menu)
	var to_delete := Array()
	to_delete.append(previous_menu)
	
	get_node("../BackgroundShader").show()
	var hierarchy_position: HierarchyNode = menu_hierarchy.get_node("Main")
	MenuManager.get_this().hierarchy_position = hierarchy_position
	var main_menu: AspectRatioContainer = hierarchy_position.scene
	root_control.add_child(main_menu)
	
	AudioServer.set_bus_volume_db(0, linear2db(1.0))
	return to_delete


static func wait_for_loading():
	var root_control: Control = Global.root_control
	var thread: Thread = root_control.thread
	if thread.is_active():
		thread.wait_to_finish()
	var precompiler: Precompiler = root_control.get_node("Precompiler")
	while precompiler.is_processing():
		yield(root_control.get_tree(), "idle_frame")


func replace(to_replace: Spatial, replacement: Spatial):
	to_replace.replace_by(replacement)
	replacement.visible = to_replace.visible
	get_node("../DeletionManager").to_be_deleted.append(to_replace)
