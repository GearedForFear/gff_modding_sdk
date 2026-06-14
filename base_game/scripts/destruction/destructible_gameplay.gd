extends Destructible


func destroy(body: PhysicsBody):
	Pools.get_ammo().start(global_transform, body, null, 0)
	.destroy(body)


func _on_Area_area_entered(area: Area):
	destroy(area.shooter)
