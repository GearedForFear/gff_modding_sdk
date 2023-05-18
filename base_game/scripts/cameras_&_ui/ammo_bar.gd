extends ProgressBar


func _physics_process(_delta):
	var ammo: float = get_node("../../../../../..").ammo
	value = ammo
	if ammo == 100:
		modulate = Color(1, 1, 1, 0.5)
	else:
		modulate = Color(1, 1, 1, 1)
