class_name VehicleData
extends Object


var scene_resource: String
var driver_name: String
var controls: PlayerControls
var spawn: int
var score:int


static func sort_ascending(a: VehicleData, b: VehicleData) -> bool:
	return a.spawn < b.spawn
