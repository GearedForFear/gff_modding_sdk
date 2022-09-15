extends AmmoVehicle


var can_shoot: bool = true

onready var gun_timer: Timer = get_node("../GunTimer")


func _ready():
	if controls == null:
		driver_name = "Fungibber"
	if get_node("/root/RootControl/SettingsManager").shadow_amount <= 1:
		$BodyMesh.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontLeft/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontRight/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackLeft/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackRight/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
	score = 1000


func _physics_process(_delta):
	if alive:
		if controls == null:
			pass
		else:
			pass


func damage(_amount: float, reward: int, _burn: float, _shooter: VehicleBody) \
		-> int:
	return reward


func _on_GunTimer_timeout():
	can_shoot = true
