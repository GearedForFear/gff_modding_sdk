extends Area


const Money: PackedScene = preload("res://scenes/collectables/money.tscn")

var damage: float
var reward: int
var burn: float
var shooter: CombatVehicle
var deletion_manager: Node


func _ready():
	set_as_toplevel(true)
	$AnimationPlayer.play("rotation")


func _on_Lifetime_timeout():
	set_process(false)
	hide()
	deletion_manager.to_be_deleted.append(self)


func _on_Area_body_entered(body):
	if body.is_in_group("combat_vehicle") and global_transform.origin\
			.distance_to(body.global_transform.origin) < 6:
		body.apply_central_impulse((body.global_transform.origin \
				- global_transform.origin).normalized() * 5000)
		if body != shooter:
			var payout: int = body.damage(damage, reward, burn, shooter)
			if payout > 0:
				var new_money: Area = Money.instance()
				new_money.shooter = shooter
				new_money.reward = payout
				new_money.deletion_manager = deletion_manager
				body.add_child(new_money)


func _on_Area_area_entered(area):
	if area.is_in_group("destructible"):
		area.deletion_manager = deletion_manager
		area.destroy(shooter, global_transform.origin, 40.0)
