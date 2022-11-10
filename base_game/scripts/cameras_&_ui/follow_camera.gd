extends Camera


export var base_min_distance: float = 3.0
export var base_max_distance: float = 6.0
export var height: float = 1.5

var animation_player: AnimationPlayer
var rear_mirror_camera: Camera

onready var min_distance: float = base_min_distance
onready var max_distance: float = base_max_distance


func _enter_tree():
	var settings_manager: Node = get_node("/root/RootControl/SettingsManager")
	animation_player = \
			$AspectRatioContainer/Control/ResourcesBackground/ViewportContainer/Viewport/Camera/AnimationPlayer
	animation_player.play("default")
	rear_mirror_camera \
			= $AspectRatioContainer/Control/RearMirror/Viewport/Camera
	far = settings_manager.view_distance
	rear_mirror_camera.far = settings_manager.rear_view_distance
	fov = settings_manager.field_of_view
	rear_mirror_camera.fov = settings_manager.field_of_view
	if get_node("../..").controls != null:
		$AspectRatioContainer.show()
	
	# This detaches the camera transform from the parent spatial node.
	set_as_toplevel(true)


func _physics_process(_delta):
	var target = get_parent().get_global_transform().origin
	var pos = get_global_transform().origin
	var from_target = pos - target
	var velocity: float = get_node("../..").linear_velocity.length()
	
	min_distance = base_min_distance + \
			velocity / 10
	max_distance = base_max_distance + \
			velocity / 10
	
	# Check ranges.
	if from_target.length() < min_distance:
		from_target = from_target.normalized() * min_distance
	elif from_target.length() > max_distance:
		from_target = from_target.normalized() * max_distance
	
	from_target.y = height
	
	pos = lerp(target + from_target, get_node("../InterpolationTarget")\
			.get_global_transform().origin, 0.02)
	
	look_at_from_position(pos, target, Vector3.UP)
	
	rear_mirror_camera.look_at_from_position(target, pos, Vector3.UP)
	rear_mirror_camera.transform.origin.y = transform.origin.y
	
	animation_player.playback_speed = clamp(velocity / 15, 1, 4)
