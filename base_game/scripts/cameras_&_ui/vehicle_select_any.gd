extends AspectRatioContainer


func select(_number, vehicle_name: String, _player_controls):
	MenuManager.go_to("CustomizationSlots").set_vehicle(vehicle_name)
