extends Area


onready var gameplay_manager: Node = get_node("../../..")


func _on_Area_body_entered(body):
	if body.is_in_group("heist_target"):
		gameplay_manager.waypoint_entered(self, body)
