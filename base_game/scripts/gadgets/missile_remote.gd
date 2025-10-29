class_name MissileRemote
extends Object


static func down(missiles: Array):
	for n in missiles:
		n.target.y -= 1.0


static func left(missiles: Array):
	for n in missiles:
		n.target -= n.global_transform.basis.x


static func right(missiles: Array):
	for n in missiles:
		n.target += n.global_transform.basis.x
