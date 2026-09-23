class_name Array2dResource
extends Resource


export var rows: Array = [[]]


func get_value(position: Array):
	return rows[position[0]][position[1]]


func get_all() -> Array:
	var return_value := Array()
	for n in rows:
		return_value.append_array(n)
	return return_value


func find(what) -> Array:
	for n in rows.size():
		var found_at_position: int = rows[n].find(what)
		if found_at_position != -1:
			return [n, found_at_position]
	
	return []


func is_out_of_bounds(position: Array) -> bool:
	return is_out_of_horizontal_bounds(position[0]) \
			or is_out_of_vertical_bounds(position[1])


func is_out_of_horizontal_bounds(position: int) -> bool:
	if position < 0:
		return true
	for n in rows:
		if position >= n.size():
			return true
	
	return false


func is_out_of_vertical_bounds(position: int) -> bool:
	return position < 0 or position >= rows.size()
