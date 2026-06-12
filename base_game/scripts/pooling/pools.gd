class_name Pools
extends Node


const BULLETS_AVAILABLE := Array()
const MONEY_AVAILABLE := Array()
const EXPLOSIONS_AVAILABLE := Array()
const SPARKS_AVAILABLE := Array()
const MISSILES_AVAILABLE := Array()
const GRENADES_AVAILABLE := Array()
const BUZZSAWS_AVAILABLE := Array()
const CHAINSAWS_AVAILABLE := Array()
const CARTRIDGE_CASES_AVAILABLE := Array()
const CARTRIDGE_LINKS_AVAILABLE := Array()

var bullet: PackedScene
var chainsaw: PackedScene
var missile: PackedScene
var grenade: PackedScene
var buzzsaw: PackedScene
var explosion: PackedScene
var money: PackedScene
var sparks: PackedScene
var cartridge_case: PackedScene
var cartridge_link: PackedScene
var homing_missile_script: GDScript
var straight_missile_script: GDScript


func _ready():
	Global.pools = self
	for n in [BULLETS_AVAILABLE, MONEY_AVAILABLE, EXPLOSIONS_AVAILABLE,
			SPARKS_AVAILABLE, CHAINSAWS_AVAILABLE, MISSILES_AVAILABLE,
			GRENADES_AVAILABLE, BUZZSAWS_AVAILABLE, CARTRIDGE_CASES_AVAILABLE,
			CARTRIDGE_LINKS_AVAILABLE]:
		n.clear()
	
	bullet = load("res://scenes/weapon_components/bullet.tscn")
	money = load("res://scenes/collectibles/money.tscn")
	explosion = load("res://scenes/destruction/explosion.tscn")
	if OS.get_current_video_driver() == OS.VIDEO_DRIVER_GLES3:
		sparks = load("res://scenes/particles/sparks.tscn")
		SPARKS_AVAILABLE.append_array($Sparks.get_children())
	else:
		sparks = load("res://scenes/particles/sparks.tscn")
	chainsaw = load("res://scenes/weapon_components/chainsaw.tscn")
	missile = load("res://scenes/weapon_components/missile.tscn")
	grenade = load("res://scenes/weapon_components/grenade.tscn")
	buzzsaw = load("res://scenes/weapon_components/buzzsaw.tscn")
	cartridge_case = load("res://scenes/weapon_components/cartridge_case.tscn")
	cartridge_link = load("res://scenes/weapon_components/cartridge_link.tscn")
	homing_missile_script = load(
			"res://scripts/weapon_compontents/homing_missile.gd")
	straight_missile_script = load(
			"res://scripts/weapon_compontents/straight_missile.gd")
	
	BULLETS_AVAILABLE.append_array($Bullets.get_children())
	MONEY_AVAILABLE.append_array($Money.get_children())
	EXPLOSIONS_AVAILABLE.append_array($Explosions.get_children())
	CHAINSAWS_AVAILABLE.append_array($Chainsaws.get_children())
	MISSILES_AVAILABLE.append_array($Missiles.get_children())
	GRENADES_AVAILABLE.append_array($Grenades.get_children())
	BUZZSAWS_AVAILABLE.append_array($Buzzsaws.get_children())
	CARTRIDGE_CASES_AVAILABLE.append_array($CartridgeCases.get_children())
	CARTRIDGE_LINKS_AVAILABLE.append_array($CartridgeLinks.get_children())
	
	for n in CARTRIDGE_CASES_AVAILABLE:
		n.pool = CARTRIDGE_CASES_AVAILABLE
	for n in CARTRIDGE_LINKS_AVAILABLE:
		n.pool = CARTRIDGE_LINKS_AVAILABLE


func get_bullet() -> StraightProjectile:
	var return_value: StraightProjectile
	if BULLETS_AVAILABLE.empty():
		return_value = bullet.instance()
		$Bullets.add_child(return_value)
	else:
		return_value = BULLETS_AVAILABLE.pop_back()
	return_value.set_type(false, Projectile.ImpactTypes.NORMAL)
	return return_value


func get_sniper_bullet() -> StraightProjectile:
	var return_value: StraightProjectile
	if BULLETS_AVAILABLE.empty():
		return_value = bullet.instance()
		$Bullets.add_child(return_value)
	else:
		return_value = BULLETS_AVAILABLE.pop_back()
	return_value.set_type(true, Projectile.ImpactTypes.NORMAL)
	return return_value


func get_acid_bullet() -> StraightProjectile:
	var return_value: StraightProjectile
	if BULLETS_AVAILABLE.empty():
		return_value = bullet.instance()
		$Bullets.add_child(return_value)
	else:
		return_value = BULLETS_AVAILABLE.pop_back()
	return_value.set_type(false, Projectile.ImpactTypes.ACID)
	return return_value


func get_ricochet_bullet() -> StraightProjectile:
	var return_value: StraightProjectile
	if BULLETS_AVAILABLE.empty():
		return_value = bullet.instance()
		$Bullets.add_child(return_value)
	else:
		return_value = BULLETS_AVAILABLE.pop_back()
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


static func get_grenade() -> ArcProjectile:
	var this: Pools = Global.pools
	if not GRENADES_AVAILABLE.empty():
		return GRENADES_AVAILABLE.pop_back()
	var new: ArcProjectile = this.grenade.instance()
	this.get_node("Grenades").add_child(new)
	return new


static func get_buzzsaw() -> StraightProjectile:
	var this: Pools = Global.pools
	if not BUZZSAWS_AVAILABLE.empty():
		return BUZZSAWS_AVAILABLE.pop_back()
	var new: StraightProjectile = this.buzzsaw.instance()
	this.get_node("Buzzsaws").add_child(new)
	return new


static func get_chainsaw() -> ArcProjectile:
	var this: Pools = Global.pools
	if not CHAINSAWS_AVAILABLE.empty():
		return CHAINSAWS_AVAILABLE.pop_back()
	var new: ArcProjectile = this.chainsaw.instance()
	this.get_node("Chainsaws").add_child(new)
	return new


func get_money() -> Area:
	if not MONEY_AVAILABLE.empty():
		return MONEY_AVAILABLE.pop_back()
	var new: Area = money.instance()
	$Money.add_child(new)
	return new


func get_explosion() -> Area:
	if not EXPLOSIONS_AVAILABLE.empty():
		return EXPLOSIONS_AVAILABLE.pop_back()
	var new: Area = explosion.instance()
	$Explosions.add_child(new)
	return new


func get_sparks() -> GeometryInstance:
	if not SPARKS_AVAILABLE.empty():
		return SPARKS_AVAILABLE.pop_back()
	var new: GeometryInstance = sparks.instance()
	$Sparks.add_child(new)
	return new


func get_cartridge_case() -> DynamicShadowBody:
	if not CARTRIDGE_CASES_AVAILABLE.empty():
		return CARTRIDGE_CASES_AVAILABLE.pop_back()
	var new: DynamicShadowBody = cartridge_case.instance()
	new.pool = CARTRIDGE_CASES_AVAILABLE
	$CartridgeCases.add_child(new)
	return new


func get_cartridge_link() -> DynamicShadowBody:
	if not CARTRIDGE_LINKS_AVAILABLE.empty():
		return CARTRIDGE_LINKS_AVAILABLE.pop_back()
	var new: DynamicShadowBody = cartridge_link.instance()
	new.pool = CARTRIDGE_LINKS_AVAILABLE
	$CartridgeLinks.add_child(new)
	return new
