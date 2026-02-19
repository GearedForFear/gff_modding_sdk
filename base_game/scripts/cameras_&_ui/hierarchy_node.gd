class_name HierarchyNode
extends Node


export var scene_path: String
export var twin: NodePath
export var lock_escape := false

# TODO Find a better solution
export var hack := false

var scene: Control


func instantiate_scene():
	if twin.is_empty():
		if scene_path == "":
			return
		scene = ResourceLoader.load(scene_path, "PackedScene").instance()
		if hack:
			ResourceLoader.load(scene_path, "PackedScene").instance()
	else:
		scene = get_node(twin).scene
