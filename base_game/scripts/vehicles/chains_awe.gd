extends AmmoVehicle


const Sniper_Bullet: PackedScene \
		= preload("res://scenes/weapon_components/sniper_bullet.tscn")
const Chainsaw: PackedScene \
		= preload("res://scenes/weapon_components/chainsaw.tscn")

export var sniper_damage: float = 20.0
export var sniper_reward: int = 10
export var sniper_burn: float = 0.4
export var sniper_ammo_cost: float = 10.0

export var launcher_damage: float = 20.0
export var launcher_reward: int = 20
export var launcher_burn: float = 0.1
export var launcher_ammo_cost: float = 10.0

var can_shoot_sniper: bool = true
var can_shoot_launcher: bool = true

onready var sniper_timer: Timer = get_node("../SniperTimer")
onready var launcher_timer: Timer = get_node("../LauncherTimer")


func _ready():
	if controls == null:
		driver_name = "Chain's Awe"
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
		$ChainsawFrontLeft.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$ChainsawFrontRight.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$ChainsawBackLeft.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$ChainsawBackRight.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$ChainsawLauncher.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF


func _physics_process(_delta):
	if alive:
		if controls == null:
			var collider: PhysicsBody = $ShotPositionSniper.get_collider()
			if can_shoot_sniper and ammo >= sniper_ammo_cost and \
					collider != null \
					and collider.is_in_group("combat_vehicle") \
					and collider.score >= 100:
				shoot_sniper()
				get_node("../StuckTimer").start()
		else:
			if can_shoot_sniper and ammo >= sniper_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				shoot_sniper()
			if can_shoot_launcher and ammo >= launcher_ammo_cost \
					and Input.is_action_pressed(controls.weapon_back):
				shoot_chainsaw()


func shoot_sniper():
	ammo -= sniper_ammo_cost
	can_shoot_sniper = false
	sniper_timer.start()
	
	var new_bullet: Area = Sniper_Bullet.instance()
	$ShotPositionSniper.add_child(new_bullet)
	new_bullet.damage = sniper_damage
	new_bullet.reward = sniper_reward
	new_bullet.burn = sniper_burn
	new_bullet.shooter = self
	new_bullet.deletion_manager = deletion_manager
	
	if gles3:
		$MuzzleFlash.emitting = true
	else:
		$CPUMuzzleFlash.emitting = true


func shoot_chainsaw():
	ammo -= launcher_ammo_cost
	can_shoot_launcher = false
	launcher_timer.start()
	
	var new_chainsaw: Area = Chainsaw.instance()
	$ShotPositionLauncher.add_child(new_chainsaw)
	new_chainsaw.damage = launcher_damage
	new_chainsaw.reward = launcher_reward
	new_chainsaw.burn = launcher_burn
	new_chainsaw.shooter = self
	new_chainsaw.deletion_manager = deletion_manager


func _on_SniperTimer_timeout():
	can_shoot_sniper = true


func _on_LauncherTimer_timeout():
	can_shoot_launcher = true
