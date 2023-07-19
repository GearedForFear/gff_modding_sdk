class_name DynamicShadowBody
extends RigidBody


var visible_on: Array
var shadow: bool


func _ready():
	shadow = $MeshInstance.cast_shadow \
			== GeometryInstance.SHADOW_CASTING_SETTING_ON


func _on_VisibilityNotifier_camera_entered(camera):
	visible_on.append(camera)
	if not visible_on.empty() and shadow:
			$MeshInstance.cast_shadow \
					= GeometryInstance.SHADOW_CASTING_SETTING_ON


func _on_VisibilityNotifier_camera_exited(camera):
	visible_on.erase(camera)
	if visible_on.empty():
		$MeshInstance.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
