class_name SkinCollection
extends Resource


var skins := Array()
var changed_since_last_write := false
var file: File
var path: String


func get_ascii() -> PoolByteArray:
	var bytes := Array()
	for n in skins:
		var hex: String = n.get_hex() + "\n"
		bytes.append_array(hex.to_ascii())
	var return_value := PoolByteArray(bytes)
	return return_value
