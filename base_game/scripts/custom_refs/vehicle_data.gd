class_name VehicleData
extends Reference


var scene_resource: String
var controls: PlayerControls
var spawn: int
var scoreboard_record: ScoreboardRecord


static func instantiate_simple(new_instance: VehicleData,
		resource_name_small: String, controls: PlayerControls) -> VehicleData:
	var resource_name_full := complete_resource_name(resource_name_small)
	new_instance.scene_resource = resource_name_full
	new_instance.controls = controls
	return new_instance


static func sort_spawn(a: VehicleData, b: VehicleData) -> bool:
	return a.spawn < b.spawn


static func complete_resource_name(resource_name_small: String) -> String:
	return "res://scenes/vehicles/" + resource_name_small + ".tscn"
