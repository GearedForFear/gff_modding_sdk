extends Camera


const BASE_MIN_DISTANCE: float = 3.0
const BASE_MAX_DISTANCE: float = 6.0

var animation_player: AnimationPlayer
var rear_mirror_camera: Camera
var y_velocity: float = 0.0

onready var min_distance: float = BASE_MIN_DISTANCE
onready var max_distance: float = BASE_MAX_DISTANCE


func _enter_tree():
	var settings_manager: Node = get_node("/root/RootControl/SettingsManager")
	animation_player = \
			$AspectRatioContainer/Control/Resources/ViewportContainer/Viewport/Camera/AnimationPlayer
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
	var target = get_parent().global_translation
	var pos = global_translation
	var from_target = pos - target
	var velocity: float = get_node("../..").linear_velocity.length()
	
	min_distance = BASE_MIN_DISTANCE + \
			velocity / 10
	max_distance = BASE_MAX_DISTANCE + \
			velocity / 10
	
	# Check ranges.
	if from_target.length() < min_distance:
		from_target = from_target.normalized() * min_distance
	elif from_target.length() > max_distance:
		from_target = from_target.normalized() * max_distance
	
	y_velocity = lerp(y_velocity, \
			clamp(get_node("../..").linear_velocity.y, -20, 2), 0.2)
	from_target.y = y_velocity * -0.3 + 1.5
	
	pos = lerp(target + from_target, get_node("../InterpolationTarget")\
			.global_translation, 0.02)
	
	look_at_from_position(pos, target, Vector3.UP)
	
	rear_mirror_camera.look_at_from_position(target, pos, Vector3.UP)
	rear_mirror_camera.transform.origin.y = transform.origin.y
	
	animation_player.playback_speed = clamp(velocity / 15, 1, 4)
