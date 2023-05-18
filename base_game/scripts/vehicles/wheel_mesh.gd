extends ShadowSetter


var interpolated_parent: bool = true
var on_screen: bool = true
var wait: bool = false


func _process(_delta):
	if interpolated_parent and on_screen:
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


func _on_VisibilityNotifier_screen_entered():
	on_screen = true


func _on_VisibilityNotifier_screen_exited():
	on_screen = false
