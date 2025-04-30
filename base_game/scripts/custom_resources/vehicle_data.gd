class_name VehicleData
extends Object


var scene_resource: String
var controls: PlayerControls
var spawn: int
var scoreboard_record: ScoreboardRecord


static func sort_spawn(a: VehicleData, b: VehicleData) -> bool:
	return a.spawn < b.spawn
