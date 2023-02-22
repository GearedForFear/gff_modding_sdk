extends Area


const Money: PackedScene = preload("res://scenes/collectables/money.tscn")
const Sparks: PackedScene = preload("res://scenes/destruction/sparks.tscn")
const ImpactLight: PackedScene \
		= preload("res://scenes/destruction/bullet_impact_light.tscn")
const ImpactMedium: PackedScene \
		= preload("res://scenes/destruction/bullet_impact_medium.tscn")
const ImpactHeavy: PackedScene \
		= preload("res://scenes/destruction/bullet_impact_heavy.tscn")

export var speed: float = 1.0

var damage: float
var reward: int
var burn: float
var acid_duration: int = 0
var shooter: CombatVehicle
var deletion_manager: Node


func _ready():
	set_as_toplevel(true)
	$Lifetime.wait_time *= 60.0 \
			/ ProjectSettings.get_setting("physics/common/physics_fps")
	$Lifetime.start()


func _physics_process(_delta):
	translation += transform.basis.z * speed


func _on_Lifetime_timeout():
	set_process(false)
	hide()
	deletion_manager.to_be_deleted.append(self)


func _on_Area_body_entered(body):
	if body != shooter:
		if body.is_in_group("combat_vehicle"):
			var impact: AudioStreamPlayer3D
			if body.alive == false:
				impact = ImpactLight.instance()
			elif damage < 20:
				impact = ImpactMedium.instance()
			else:
				impact = ImpactHeavy.instance()
			impact.deletion_manager = deletion_manager
			body.add_child(impact)
			
			$RayCast.force_raycast_update()
			var payout: int = body.damage(damage, reward, burn, shooter)
			if acid_duration > 0:
				body.acid_duration += acid_duration
				body.acid_cause = shooter
			if payout > 0:
				var new_money: Area = Money.instance()
				new_money.shooter = shooter
				new_money.reward = payout
				new_money.deletion_manager = deletion_manager
				body.add_child(new_money)
				new_money.global_transform.origin = \
						$RayCast.get_collision_point()
				if $RayCast.get_collision_point() == Vector3.ZERO:
					new_money.global_transform.origin = global_transform.origin
			
			var new_sparks: MeshInstance = Sparks.instance()
			new_sparks.deletion_manager = deletion_manager
			body.add_child(new_sparks)
			new_sparks.global_transform = global_transform
			new_sparks.rotation.z = randi() / TAU
			new_sparks.global_transform.origin = $RayCast.get_collision_point()
			if $RayCast.get_collision_point() == Vector3.ZERO:
				new_sparks.global_transform.origin = global_transform.origin
		set_process(false)
		hide()
		deletion_manager.to_be_deleted.append(self)
