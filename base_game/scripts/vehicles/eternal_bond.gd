extends AmmoVehicle


const Bullet: PackedScene \
		= preload("res://scenes/weapon_components/bullet.tscn")
const CartridgeCase: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_case.tscn")
const CartridgeLink: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_link.tscn")

export var bullet_damage: float = 2.0
export var bullet_reward: int = 1
export var bullet_burn: float = 0.4
export var bullet_ammo_cost: float = 0.5

var can_shoot: bool = true

onready var gun_timer: Timer = get_node("../GunTimer")


func _ready():
	if controls == null:
		driver_name = "Eternal Bond"
	if get_node("/root/RootControl/SettingsManager").shadow_amount <= 1:
		$BodyMesh.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$BodyMesh2.cast_shadow = GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontLeft/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontRight/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackLeft/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackRight/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontLeft2/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelFrontRight2/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackLeft2/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF
		$WheelBackRight2/Mesh.cast_shadow = \
				GeometryInstance.SHADOW_CASTING_SETTING_OFF


func _physics_process(_delta):
	if alive:
		if controls == null:
			var left_collider: PhysicsBody = $ShotPositionLeft.get_collider()
			var right_collider: PhysicsBody = $ShotPositionRight.get_collider()
			if can_shoot and ammo >= bullet_ammo_cost and ((left_collider \
					!= null and left_collider.is_in_group("combat_vehicle") \
					and left_collider.score >= 100) or (right_collider != null \
					and right_collider.is_in_group("combat_vehicle") \
					and right_collider.score >= 100)):
				shoot(true)
				get_node("../StuckTimer").start()
			elif gun_timer.is_stopped():
				shoot(false)
		else:
			if can_shoot and ammo >= bullet_ammo_cost \
					and Input.is_action_pressed(controls.weapon_front):
				shoot(true)
			elif gun_timer.is_stopped():
				shoot(false)
	else:
		shoot(false)


func shoot(var b: bool):
	if b:
		can_shoot = false
		gun_timer.start()
		
		var new_bullet: Area = Bullet.instance()
		$ShotPositionLeft.add_child(new_bullet)
		new_bullet.damage = bullet_damage
		new_bullet.reward = bullet_reward
		new_bullet.burn = bullet_burn
		new_bullet.shooter = self
		new_bullet.deletion_manager = deletion_manager
		new_bullet = Bullet.instance()
		$ShotPositionRight.add_child(new_bullet)
		new_bullet.damage = bullet_damage
		new_bullet.reward = bullet_reward
		new_bullet.burn = bullet_burn
		new_bullet.shooter = self
		new_bullet.deletion_manager = deletion_manager
		
		var new_case: RigidBody = CartridgeCase.instance()
		$CartridgeExitLeft.add_child(new_case)
		new_case.set_as_toplevel(true)
		new_case.apply_central_impulse(new_case.transform.basis.x * 10)
		deletion_manager.other_rigid_bodies.append(new_case)
		new_case = CartridgeCase.instance()
		$CartridgeExitRight.add_child(new_case)
		new_case.set_as_toplevel(true)
		new_case.apply_central_impulse(new_case.transform.basis.x * 10)
		deletion_manager.other_rigid_bodies.append(new_case)
		
		var new_link: RigidBody = CartridgeLink.instance()
		$CartridgeExitLeft.add_child(new_link)
		new_link.set_as_toplevel(true)
		new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 - 10)\
				/ 10000, (new_case.transform.basis.x * -1 \
				+ new_link.transform.basis.y) * 4)
		deletion_manager.other_rigid_bodies.append(new_link)
		new_link = CartridgeLink.instance()
		$CartridgeExitRight.add_child(new_link)
		new_link.set_as_toplevel(true)
		new_link.apply_impulse(new_link.transform.basis.y * (randi() % 20 - 10)\
				/ 10000, (new_case.transform.basis.x \
				+ new_link.transform.basis.y) * 4)
		deletion_manager.other_rigid_bodies.append(new_link)
		
		ammo -= bullet_ammo_cost
		
		if gles3:
			$MuzzleFlashLeft.emitting = true
			$MuzzleFlashRight.emitting = true
		else:
			$CPUMuzzleFlashLeft.emitting = true
			$CPUMuzzleFlashRight.emitting = true
	else:
		if gles3:
			$MuzzleFlashLeft.emitting = false
			$MuzzleFlashRight.emitting = false
		else:
			$CPUMuzzleFlashLeft.emitting = false
			$CPUMuzzleFlashRight.emitting = false


func _on_GunTimer_timeout():
	can_shoot = true
