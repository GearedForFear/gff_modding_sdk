extends Pickup


func collect(body: PhysicsBody):
	body.reward(reward)


func make_available():
	Pools.MONEY_AVAILABLE.append(self)
