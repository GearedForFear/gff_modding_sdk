class_name HierarchyNode
extends Node


export var scene_path: String
export var twin: NodePath

var scene: Control


func instantiate_scene():
	if twin.is_empty():
		scene = ResourceLoader.load(scene_path, "PackedScene").instance()
	else:
		scene = get_node(twin).scene
