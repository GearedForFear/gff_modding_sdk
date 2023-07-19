extends Node


const Bullet: PackedScene \
		= preload("res://scenes/weapon_components/bullet.tscn")
const SniperBullet: PackedScene \
		= preload("res://scenes/weapon_components/sniper_bullet.tscn")
const AcidBullet: PackedScene \
		= preload("res://scenes/weapon_components/acid_bullet.tscn")
const Money: PackedScene = preload("res://scenes/collectables/money.tscn")
const Sparks: PackedScene = preload("res://scenes/destruction/sparks.tscn")
const CartridgeCase: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_case.tscn")
const CartridgeLink: PackedScene \
		= preload("res://scenes/weapon_components/cartridge_link.tscn")

onready var money_available: Array = $Money.get_children()
onready var sparks_available: Array = $Sparks.get_children()
onready var cartridge_cases_available: Array = $CartridgeCases.get_children()
onready var cartridge_links_available: Array = $CartridgeLinks.get_children()

var bullets_available: Array
var sniper_bullets_available: Array
var acid_bullets_available: Array


func _ready():
	for n in cartridge_cases_available:
		n.pool = cartridge_cases_available
	for n in cartridge_links_available:
		n.pool = cartridge_links_available


func get_bullet() -> Area:
	if not bullets_available.empty():
		return bullets_available.pop_back()
	var new: Area = Bullet.instance()
	$Bullets.add_child(new)
	return new


func get_sniper_bullet() -> Area:
	if not sniper_bullets_available.empty():
		return sniper_bullets_available.pop_back()
	var new: Area = SniperBullet.instance()
	$SniperBullets.add_child(new)
	return new


func get_acid_bullet() -> Area:
	if not acid_bullets_available.empty():
		return acid_bullets_available.pop_back()
	var new: Area = AcidBullet.instance()
	$AcidBullets.add_child(new)
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
