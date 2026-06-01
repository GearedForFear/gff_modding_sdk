class_name SkinCollection
extends Resource


var skins := Array()
var file: File


func get_ascii() -> PoolByteArray:
	var bytes := Array()
	for n in skins:
		var hex: String = n.get_hex() + "\n"
		bytes.append_array(hex.to_ascii())
	var return_value := PoolByteArray(bytes)
	return_value[-1] = 4
	return return_value
