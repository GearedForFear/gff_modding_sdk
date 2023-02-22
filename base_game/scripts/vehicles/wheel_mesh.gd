extends MeshInstance


var interpolated_parent: bool = true
var wait: bool = false


func _process(_delta):
	if interpolated_parent:
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
