class_name SelectSlot
extends MenuViewportContainer


export var vehicle_name: String
export var locked: bool = false


func _ready():
	if locked:
		$Viewport/Spatial/Body.propagate_call("hide_texture")
