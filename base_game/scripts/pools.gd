extends Node


const Bullet: PackedScene \
		= preload("res://scenes/weapon_components/bullet.tscn")
const Missile: PackedScene \
		= preload("res://scenes/weapon_components/missile.tscn")
const Grenade: PackedScene \
		= preload("res://scenes/weapon_components/grenade.tscn")
const Buzzsaw: PackedScene \
		= preload("res://scenes/weapon_components/buzzsaw.tscn")
const Chainsaw: PackedScene \
		= preload("res://scenes/weapon_components/chainsaw.tscn")
const Explosion: PackedScene \
		= preload("res://scenes/destruction/explosion.tscn")
const Money: PackedScene = preload("res://scenes/collectibles/money.tscn")
const Sparks: PackedScene = preload("res://scenes/destruction/sparks.tscn")
const CartridgeCase: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_case.tscn")
const CartridgeLink: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_link.tscn")

onready var HomingMissileScript: GDScript \
		= load("res://scripts/weapon_compontents/homing_missile.gd")
onready var StraightMissileScript: GDScript \
		= load("res://scripts/weapon_compontents/straight_missile.gd")
onready var gles3: bool = OS.get_current_video_driver() == 0

enum bullet_types {NORMAL, ACID, RICOCHET}

onready var money_available: Array = $Money.get_children()
onready var sparks_available: Array = $Sparks.get_children()
onready var cartridge_cases_available: Array = $CartridgeCases.get_children()
onready var cartridge_links_available: Array = $CartridgeLinks.get_children()

var bullets_available: Array
var missiles_available: Array
var grenades_available: Array
var buzzsaws_available: Array
var chainsaws_available: Array
var explosions_available: Array


func _ready():
	for n in missiles_available:
		n.gles3 = gles3
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
	return_value.set_type(false, bullet_types.NORMAL)
	return return_value


func get_sniper_bullet() -> StraightProjectile:
	var return_value: StraightProjectile
	if bullets_available.empty():
		return_value = Bullet.instance()
		$Bullets.add_child(return_value)
	else:
		return_value = bullets_available.pop_back()
	return_value.set_type(true, bullet_types.NORMAL)
	return return_value


func get_acid_bullet() -> StraightProjectile:
	var return_value: StraightProjectile
	if bullets_available.empty():
		return_value = Bullet.instance()
		$Bullets.add_child(return_value)
	else:
		return_value = bullets_available.pop_back()
	return_value.set_type(false, bullet_types.ACID)
	return return_value


func get_ricochet_bullet() -> StraightProjectile:
	var return_value: StraightProjectile
	if bullets_available.empty():
		return_value = Bullet.instance()
		$Bullets.add_child(return_value)
	else:
		return_value = bullets_available.pop_back()
	return_value.set_type(false, bullet_types.RICOCHET)
	return return_value


func get_homing_missile() -> Projectile:
	var return_value: Projectile
	if missiles_available.empty():
		return_value = Missile.instance()
		$Missiles.add_child(return_value)
	else:
		return_value = missiles_available.pop_back()
	return_value.set_script(HomingMissileScript)
	return_value.gles3 = gles3
	return_value.pools = self
	return return_value


func get_straight_missile() -> Projectile:
	var return_value: Projectile
	if missiles_available.empty():
		return_value = Missile.instance()
		$Missiles.add_child(return_value)
	else:
		return_value = missiles_available.pop_back()
	return_value.set_script(StraightMissileScript)
	return_value.gles3 = gles3
	return_value.pools = self
	return return_value


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


func get_sparks() -> MeshInstance:
	if not sparks_available.empty():
		return sparks_available.pop_back()
	var new: MeshInstance = Sparks.instance()
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
