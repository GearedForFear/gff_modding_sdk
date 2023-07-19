extends Area


var damage: float
var reward: int
var burn: float
var shooter: CombatVehicle
var deletion_manager: Node
var pools: Node

var interpolation_weight: float = 0.05


func _ready():
	set_as_toplevel(true)
	$Lifetime.wait_time *= 60.0 \
			/ ProjectSettings.get_setting("physics/common/physics_fps")
	$Lifetime.start()


func _physics_process(_delta):
	translation += transform.basis.z * 0.3
	global_transform = global_transform.interpolate_with(global_transform.\
			looking_at(global_translation - global_transform.basis.z \
			+ Vector3.UP, Vector3.UP), interpolation_weight)
	interpolation_weight *= 1.01


func delete():
	set_process(false)
	set_physics_process(false)
	hide()
	deletion_manager.to_be_deleted.append(self)


func _on_Area_body_entered(body):
	if body != shooter:
		if body.is_in_group("combat_vehicle"):
			rotation.z = randi() / TAU
			pools.get_sparks().start(global_transform)
			
			var payout: int = body.damage(damage, reward, burn, shooter)
			if payout > 0:
				pools.get_money().start(global_transform, shooter, body, payout)
			$ImpactVehicle.play()
		else:
			$ImpactGround.play()
		$Lifetime.stop()
		set_process(false)
		set_physics_process(false)
		hide()


func _on_Lifetime_timeout():
	delete()


func _on_ImpactVehicle_finished():
	delete()


func _on_ImpactGround_finished():
	delete()
