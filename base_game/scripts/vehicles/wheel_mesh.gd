extends ShadowSetter


var interpolated_parent: bool = true
var wait: bool = false
var visible_on: Array


func _process(_delta):
	if interpolated_parent and not visible_on.empty():
		global_translation = get_parent().get_global_transform_interpolated().origin


func _physics_process(_delta):
	if wait:
		wait = false
	else:
		interpolated_parent = true


func _notification(what):
	if what == NOTIFICATION_RESET_PHYSICS_INTERPOLATION:
		interpolated_parent = false
		wait = true


func _on_VisibilityNotifier_camera_entered(camera):
	visible_on.append(camera)


func _on_VisibilityNotifier_camera_exited(camera):
	visible_on.erase(camera)
