extends MenuViewportContainer


func _enter_tree():
	var player_amount: int = Global.root_control.player_amount
	if player_amount == 1:
		set_vehicle_visibility(6)
	else:
		set_vehicle_visibility(player_amount)


func set_vehicle_visibility(player_amount: int):
	for n in range(2, 7):
		get_vehicle(n).visible = player_amount >= n


func get_vehicle(number: int) -> VehicleBody:
	return get_node("Viewport/Body" + String(number)) as VehicleBody
