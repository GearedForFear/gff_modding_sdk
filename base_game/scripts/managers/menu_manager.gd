class_name MenuManager
extends Node


onready var hierarchy_position: HierarchyNode = ResourceLoader.load(
		"res://scenes/cameras_&_ui/menus/menu_hierarchy.tscn",
		"PackedScene").instance().get_node("Main")


static func get_this() -> MenuManager:
	return Global.root_control.get_node("MenuManager") as MenuManager


static func go_to(name: String) -> Control:
	var this: MenuManager = get_this()
	var position: HierarchyNode = this.hierarchy_position.get_node_or_null(name)
	if position == null:
		var parent: HierarchyNode = this.hierarchy_position.get_parent()
		while parent.name != "Quit":
			parent = parent.get_parent()
		position = parent.get_node(name)
	this.set_menu(position)
	return position.scene


static func escape() -> bool:
	var this: MenuManager = get_this()
	var previous: HierarchyNode = this.hierarchy_position
	var new: HierarchyNode = previous
	while new.name.begins_with("Next"):
		new = new.get_parent()
	new = new.get_parent()
	
	if new == null:
		return false
	else:
		this.set_menu(new)
		var to_grab: Control = try_paths(["Current/Menu/" + previous.name,
				"Current/Menu/Buttons/" + previous.name])
		if to_grab == null:
			pass
		else:
			to_grab.grab_focus()
	return true


func set_menu(position: HierarchyNode):
	hierarchy_position = position
	var root_control: Control = Global.root_control
	root_control.remove_child(root_control.get_node("Current"))
	root_control.add_child(position.scene)
	
	# Apply translation to nodes, that were outside the tree
	TranslationServer.set_locale(TranslationServer.get_locale())


static func next_menu(controls: Array):
	var this: MenuManager = get_this()
	var previous: HierarchyNode = this.hierarchy_position
	var new: HierarchyNode = previous.get_node("Next" + String(controls.size()))
	this.set_menu(new)
	Global.root_control.get_node("Current").propagate_call(
			"set_player_controls", [controls])


static func try_paths(paths: Array) -> Control:
	for n in paths:
		var return_value: Control= Global.root_control.get_node_or_null(n)
		if return_value != null:
			return return_value
	return null
