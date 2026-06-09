class_name Pools
extends Node


const Bullet: PackedScene \
		= preload("res://scenes/weapon_components/bullet.tscn")
var missile: PackedScene
const Grenade: PackedScene \
		= preload("res://scenes/weapon_components/grenade.tscn")
const Buzzsaw: PackedScene \
		= preload("res://scenes/weapon_components/buzzsaw.tscn")
const Chainsaw: PackedScene \
		= preload("res://scenes/weapon_components/chainsaw.tscn")
const Explosion: PackedScene \
		= preload("res://scenes/destruction/explosion.tscn")
const Money: PackedScene = preload("res://scenes/collectibles/money.tscn")
const Sparks: PackedScene = preload("res://scenes/particles/sparks.tscn")
const SparksCPU: PackedScene = preload("res://scenes/particles/sparks_cpu.tscn")
const CartridgeCase: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_case.tscn")
const CartridgeLink: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_link.tscn")
var homing_missile_script: GDScript
var straight_missile_script: GDScript

onready var money_available: Array = $Money.get_children()
onready var explosions_available: Array = $Explosions.get_children()
onready var sparks_available: Array = $Sparks.get_children()
onready var cartridge_cases_available: Array = $CartridgeCases.get_children()
onready var cartridge_links_available: Array = $CartridgeLinks.get_children()
onready var bullets_available: Array = $Bullets.get_children()
const MISSILES_AVAILABLE := Array()
onready var grenades_available: Array = $Grenades.get_children()
onready var buzzsaws_available: Array = $Buzzsaws.get_children()
onready var chainsaws_available: Array = $Chainsaws.get_children()


func _ready():
	Global.pools = self
	
	missile = load("res://scenes/weapon_components/missile.tscn")
	homing_missile_script = load(
			"res://scripts/weapon_compontents/homing_missile.gd")
	straight_missile_script = load(
			"res://scripts/weapon_compontents/straight_missile.gd")
	
	MISSILES_AVAILABLE.append_array($Missiles.get_children())
	
	for n in cartridge_cases_available:
		n.pool = cartridge_cases_available
	for n in cartridge_links_available:
		n.pool = cartridge_links_available


func get_bullet() -> StraightProjectile:
	var return_value: StraightProjectile
	if bullets_available.empty():
		return_value = Bullet.instance()
		$Bullets.add_child(return_value)
	else:
		return_value = bullets_available.pop_back()
	return_value.set_type(false, Projectile.ImpactTypes.NORMAL)
	return return_value


func get_sniper_bullet() -> StraightProjectile:
	var return_value: StraightProjectile
	if bullets_available.empty():
		return_value = Bullet.instance()
		$Bullets.add_child(return_value)
	else:
		return_value = bullets_available.pop_back()
	return_value.set_type(true, Projectile.ImpactTypes.NORMAL)
	return return_value


func get_acid_bullet() -> StraightProjectile:
	var return_value: StraightProjectile
	if bullets_available.empty():
		return_value = Bullet.instance()
		$Bullets.add_child(return_value)
	else:
		return_value = bullets_available.pop_back()
	return_value.set_type(false, Projectile.ImpactTypes.ACID)
	return return_value


func get_ricochet_bullet() -> StraightProjectile:
	var return_value: StraightProjectile
	if bullets_available.empty():
		return_value = Bullet.instance()
		$Bullets.add_child(return_value)
	else:
		return_value = bullets_available.pop_back()
	return_value.set_type(false, Projectile.ImpactTypes.RICOCHET)
	return return_value


static func get_homing_missile() -> Projectile:
	var this: Pools = Global.pools
	var return_value: Projectile = this.get_missile()
	return_value.set_script(this.homing_missile_script)
	return return_value


static func get_straight_missile() -> Projectile:
	var this: Pools = Global.pools
	var return_value: Projectile = this.get_missile()
	return_value.set_script(this.straight_missile_script)
	return return_value


func get_missile() -> Projectile:
	if MISSILES_AVAILABLE.empty():
		var return_value: Projectile
		return_value = missile.instance()
		get_node("Missiles").add_child(return_value)
		return return_value
	return MISSILES_AVAILABLE.pop_back()


func get_grenade() -> ArcProjectile:
	if not grenades_available.empty():
		return grenades_available.pop_back()
	var new: ArcProjectile = Grenade.instance()
	$Grenades.add_child(new)
	return new


func get_buzzsaw() -> StraightProjectile:
	if not buzzsaws_available.empty():
		return buzzsaws_available.pop_back()
	var new: StraightProjectile = Buzzsaw.instance()
	$Buzzsaws.add_child(new)
	return new


func get_chainsaw() -> ArcProjectile:
	if not chainsaws_available.empty():
		return chainsaws_available.pop_back()
	var new: ArcProjectile = Chainsaw.instance()
	$Chainsaws.add_child(new)
	return new


func get_explosion() -> Area:
	if not explosions_available.empty():
		return explosions_available.pop_back()
	var new: Area = Explosion.instance()
	$Explosions.add_child(new)
	return new


func get_money() -> Area:
	if not money_available.empty():
		return money_available.pop_back()
	var new: Area = Money.instance()
	$Money.add_child(new)
	return new


func get_sparks() -> GeometryInstance:
	if not sparks_available.empty():
		return sparks_available.pop_back()
	var new: GeometryInstance
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		new = Sparks.instance()
	else:
		new = SparksCPU.instance()
	$Sparks.add_child(new)
	return new


func get_cartridge_case() -> DynamicShadowBody:
	if not cartridge_cases_available.empty():
		return cartridge_cases_available.pop_back()
	var new: DynamicShadowBody = CartridgeCase.instance()
	new.pool = cartridge_cases_available
	$CartridgeCases.add_child(new)
	return new


func get_cartridge_link() -> DynamicShadowBody:
	if not cartridge_links_available.empty():
		return cartridge_links_available.pop_back()
	var new: DynamicShadowBody = CartridgeLink.instance()
	new.pool = cartridge_links_available
	$CartridgeLinks.add_child(new)
	return new
