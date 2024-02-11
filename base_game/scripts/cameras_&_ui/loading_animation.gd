extends AnimationPlayer


func _on_Loading_visibility_changed():
	if get_parent().visible:
		play("loading")
	else:
		stop()
