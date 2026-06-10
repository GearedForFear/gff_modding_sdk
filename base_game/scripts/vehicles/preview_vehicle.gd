extends CustomizableVehicle


export var second_boost: Resource


func _enter_tree():
	if skins_implemented:
		set_skin(0)
