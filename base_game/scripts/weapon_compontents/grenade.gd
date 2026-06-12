extends ArcProjectile


func make_available():
	get_node("../..").GRENADES_AVAILABLE.append(self)
