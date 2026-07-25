class_name FileReader


const ASCII_LINE_FEED: int = 10


static func read_ini(path: String) -> Dictionary:
	var file := File.new()
	if not file.file_exists(path):
		return Dictionary()
	
	file.open(path, File.READ)
	var file_length: int = file.get_len()
	var regex := RegEx.new()
	regex.compile("[a-z_]+=([0-9]+(\\.[0-9]+)?|(true)|(false))")
	var return_value := Dictionary()
	var current_line := ""
	while file.get_position() < file_length:
		var next_char: String = char(file.get_8())
		if next_char == '\n':
			var regex_match: RegExMatch = regex.search(current_line)
			if regex_match != null:
				var key_and_value: PoolStringArray = \
						regex_match.subject.split('=', false, 1)
				var key: String = key_and_value[0]
				var value
				if key_and_value[1].is_valid_integer():
					value = int(key_and_value[1])
				elif key_and_value[1].is_valid_float():
					value = float(key_and_value[1])
				else:
					value = bool(key_and_value[1])
				return_value[key] = value
			current_line = ""
		else:
			current_line += next_char
	file.close()
	return return_value


static func read_skin_collection(vehicle_name: String) -> SkinCollection:
	var path := "user://" + vehicle_name + ".ascii"
	var file := File.new()
	if not file.file_exists(path):
		return new_empty_skin_collection(path)
	
	file.open(path, File.READ)
	var default: VehicleSkin = ResourceLoader.load(
				"res://resources/custom/skins/default/" + vehicle_name
				+ ".tres")
	var monster_truck: bool = default.monster_truck
	var has_teeth: bool = default.has_teeth
	var skins := Array()
	var file_length: int = file.get_len()
	while file.get_position() < file_length:
		var ascii: PoolByteArray = file.get_buffer(16)
		var hex := ascii.get_string_from_ascii()
		var new_skin := VehicleSkin.new()
		if new_skin.set_hex(hex):
			new_skin.vehicle_name = vehicle_name
			new_skin.monster_truck = monster_truck
			new_skin.has_teeth = has_teeth
			skins.append(new_skin)
		while (file.get_8() != ASCII_LINE_FEED) \
				and file.get_position() < file_length:
			pass
	file.close()
	
	var return_value: SkinCollection = SkinCollection.new()
	return_value.skins = skins
	return_value.file = file
	return_value.path = path
	return return_value


static func new_empty_skin_collection(path: String) -> SkinCollection:
	var file := File.new()
	file.open(path, File.WRITE)
	file.close()
	var return_value: SkinCollection = SkinCollection.new()
	return_value.file = file
	return_value.path = path
	return return_value
