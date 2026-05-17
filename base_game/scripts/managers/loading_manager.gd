class_name LoadingManager
extends Node


static func prepare():
	var root_control: Control = Global.root_control
	SettingsManager.get_this().start()
	Precompiler.get_this().add_materials()
	ResourceManager.get_this().load_resources()
	MaterialManager.get_this().update_settings()
	AudioServer.set_bus_volume_db(0, linear2db(1.0))
	
	var menu_hierarchy: Node = ResourceLoader.load(
			"res://scenes/cameras_&_ui/menus/menu_hierarchy.tscn",
			"PackedScene").instance()
	menu_hierarchy.propagate_call("instantiate_scene")
	
	var hierarchy_position: HierarchyNode = menu_hierarchy.get_node("Main")
	MenuManager.get_this().hierarchy_position = hierarchy_position
	var main_menu: AspectRatioContainer = hierarchy_position.scene
	root_control.add_child(main_menu)
