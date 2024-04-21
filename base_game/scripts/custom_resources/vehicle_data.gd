class_name VehicleData
extends Object


var scene_resource: String
var driver_name: String
var controls: PlayerControls
var spawn: int
var score:int


static func sort_spawn(a: VehicleData, b: VehicleData) -> bool:
	return a.spawn < b.spawn


static func sort_score(a: VehicleData, b: VehicleData) -> bool:
	return a.score > b.score
