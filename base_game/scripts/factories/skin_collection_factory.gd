class_name SkinCollectionFactory


static func load_collection(vehicle_name: String) -> SkinCollection:
	var return_value: SkinCollection = \
			FileReader.read_skin_collection(vehicle_name)
	var default: VehicleSkin = ResourceLoader.load(
			"res://resources/custom/skins/default/" + vehicle_name + ".tres")
	while return_value.skins.size() < 12:
		var new_skin := VehicleSkin.new()
		new_skin.copy(default)
		return_value.skins.append(new_skin)
		return_value.changed_since_last_write = true
	
	FileWriter.try_write_skin_collection(return_value)
	return return_value
