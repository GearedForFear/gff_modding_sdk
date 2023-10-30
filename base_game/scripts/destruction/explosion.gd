extends Area


var damage: float
var reward: int
var burn: float
var shooter: CombatVehicle
var deletion_manager: Node


func _ready():
	set_as_toplevel(true)
	$AnimationPlayer.play("rotation")


func _on_CollisionTime_timeout():
	hide()
	$CollisionShape.disabled = true


func _on_Lifetime_timeout():
	set_process(false)
	deletion_manager.to_be_deleted.append(self)


func _on_Area_body_entered(body):
	if body.is_in_group("combat_vehicle") and global_transform.origin\
			.distance_to(body.global_transform.origin) < 6:
		body.apply_central_impulse((body.global_transform.origin \
				- global_transform.origin).normalized() * 5000)
		if body != shooter:
			var payout: int = body.damage(damage, reward, burn, shooter)
			if payout > 0:
				deletion_manager.get_node("../Pools").get_money().start(\
						global_transform, shooter, body, payout)


func _on_Area_area_entered(area):
	if area.is_in_group("destructible"):
		area.deletion_manager = deletion_manager
		area.destroy(shooter, global_transform.origin, 40.0)
