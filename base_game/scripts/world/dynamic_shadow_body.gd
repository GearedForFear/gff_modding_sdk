class_name DynamicShadowBody
extends RigidBody


var camera_count: int = 0
var shadow: bool


func _ready():
	shadow = $MeshInstance.cast_shadow \
			== GeometryInstance.SHADOW_CASTING_SETTING_ON


func _on_VisibilityNotifier_camera_entered(_camera):
	camera_count += 1
	if camera_count != 0 and shadow:
			$MeshInstance.cast_shadow \
					= GeometryInstance.SHADOW_CASTING_SETTING_ON


func _on_VisibilityNotifier_camera_exited(_camera):
	camera_count -= 1
	if camera_count == 0:
		$MeshInstance.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
