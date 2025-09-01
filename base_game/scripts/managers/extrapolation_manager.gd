class_name ExtrapolationManager
extends Node


# to convert rpm to radians per usec
const CONVERSION_FACTOR: float = PI / 60_000_000

var last_physics_tick_usec: int
var wheel_extrapolation_factor: float


func _ready():
	Global.extrapolation_manager = self


func _physics_process(_delta):
	last_physics_tick_usec = Time.get_ticks_usec()


func _process(_delta):
	wheel_extrapolation_factor = (Time.get_ticks_usec()
			- last_physics_tick_usec) * CONVERSION_FACTOR
