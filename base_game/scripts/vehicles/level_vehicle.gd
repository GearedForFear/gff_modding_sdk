class_name LevelVehicle
extends CombatVehicle


signal xp_changed(new, level)

export var level_cap: bool = true

var level: int = 1
var xp: int = 0
var burst_remaining: int = 0
var movement_lock_remaining: int = 0


func _physics_process(_delta):
	level = xp / 2000 + 1
	xp -= 10
	if level_cap:
		level = clamp(level, 1, 5)
		xp = clamp(xp, 0, 10000)
	emit_signal("xp_changed", xp, level)
