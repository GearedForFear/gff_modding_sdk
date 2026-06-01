class_name SkinCollectionFactory


const ASCII_END_OF_TRANSMISSION: int = 4


static func load_collection(vehicle_name: String) -> SkinCollection:
	var return_value := SkinCollection.new()
	var file := File.new()
	var path := "user://" + vehicle_name + ".ascii"
	if file.file_exists(path):
		file.open(path, File.READ)
		while true:
			var ascii: PoolByteArray = file.get_buffer(16)
			var hex := ascii.get_string_from_ascii()
			var new_skin := VehicleSkin.new()
			new_skin.vehicle_name = vehicle_name
			new_skin.set_hex(hex)
			return_value.skins.append(new_skin)
			if (file.get_8() == ASCII_END_OF_TRANSMISSION):
				break
	else:
		var default: VehicleSkin = ResourceLoader.load(
				"res://resources/custom/skins/default/" + vehicle_name
				+ ".tres")
		for n in 12:
			var new_skin := VehicleSkin.new()
			new_skin.copy(default)
			return_value.skins.append(new_skin)
		file.open(path, File.WRITE)
		file.store_buffer(return_value.get_ascii())
		file.close()
	
	return_value.file = file
	return return_value
