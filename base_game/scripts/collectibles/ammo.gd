extends Pickup


func collect(body: PhysicsBody):
	if body.is_in_group("ammo_vehicle"):
		body.change_ammo(100.0)


func make_available():
	Pools.AMMO_AVAILABLE.append(self)
