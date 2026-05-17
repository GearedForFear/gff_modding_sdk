class_name Math


static func round_up(input: float) -> int:
	var i := int(input)
	if input == i:
		return i
	return i + 1
