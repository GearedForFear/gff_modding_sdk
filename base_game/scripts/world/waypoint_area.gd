extends Area


func _on_Area_body_entered(body):
	if body.is_in_group("heist_target"):
		get_node("../../..").waypoint_entered(self, body)
