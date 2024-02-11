extends ArcProjectile


func make_available():
	pools.grenades_available.append(self)
