extends Area


var shooter: CombatVehicle
var spawner: CombatVehicle
var reward: int
var deletion_manager: Node
var speed_divisor: float = 20


func _ready():
	set_as_toplevel(true)
	spawner = get_parent()


func _physics_process(_delta):
	if shooter.replacement != null:
		shooter = shooter.replacement
	if speed_divisor < 0.15:
		global_transform.origin = shooter.global_transform.origin
	transform.origin += global_transform.origin.direction_to(\
			shooter.global_transform.origin).normalized() / speed_divisor
	speed_divisor *= 0.99


func _on_Area_body_entered(body):
	if body != spawner:
		body.reward(reward)
		set_process(false)
		hide()
		deletion_manager.to_be_deleted.append(self)
