extends ArcProjectile


func make_available():
	get_node("../..").grenades_available.append(self)
