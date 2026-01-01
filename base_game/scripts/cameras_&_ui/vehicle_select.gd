extends AspectRatioContainer


var selected_vehicle := Array()
var controls := Array()


func _enter_tree():
	selected_vehicle.clear()
	controls.clear()
	for n in Global.root_control.player_amount:
		selected_vehicle.append("")
		controls.append("")


func select():
	if not selected_vehicle.has(""):
		Global.root_control.play(selected_vehicle, controls)
