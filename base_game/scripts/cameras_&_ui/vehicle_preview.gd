extends Spatial


const CA_PREVIEW: PackedScene \
		= preload("res://scenes/vehicles/preview/chains_awe_preview.tscn")
const SD_PREVIEW: PackedScene \
		= preload("res://scenes/vehicles/preview/suicide_door_preview.tscn")
const GM_PREVIEW: PackedScene \
		= preload("res://scenes/vehicles/preview/grave_mistake_preview.tscn")
const MU_PREVIEW: PackedScene \
		= preload("res://scenes/vehicles/preview/metal_undertow_preview.tscn")
const FU_PREVIEW: PackedScene \
		= preload("res://scenes/vehicles/preview/fungibber_preview.tscn")
const WW_PREVIEW: PackedScene \
		= preload("res://scenes/vehicles/preview/warm_welcome_preview.tscn")
const TU_PREVIEW: PackedScene \
		= preload("res://scenes/vehicles/preview/turbulence_preview.tscn")
const EB_PREVIEW: PackedScene \
		= preload("res://scenes/vehicles/preview/eternal_bond_preview.tscn")
const RE_PREVIEW: PackedScene \
		= preload("res://scenes/vehicles/preview/restless_preview.tscn")
const WR_PREVIEW: PackedScene \
		= preload("res://scenes/vehicles/preview/well_raised_preview.tscn")
const NM_PREVIEW: PackedScene \
		= preload("res://scenes/vehicles/preview/no_match_preview.tscn")

onready var container = get_node("../..")
onready var unavailable = container.get_node("../Unavailable")


func _enter_tree():
	add_child(CA_PREVIEW.instance())
	yield(get_tree(), "idle_frame")
	show()


func update_vehicle(category: int, vehicle: int):
	show_unavailable(false)
	var preview_vehicle: VehicleBody
	match category:
		VehicleSelect.category_names.NITRO:
			match vehicle:
				0:
					preview_vehicle = CA_PREVIEW.instance()
				1:
					preview_vehicle = SD_PREVIEW.instance()
				2:
					preview_vehicle = GM_PREVIEW.instance()
				3:
					preview_vehicle = MU_PREVIEW.instance()
				4:
					preview_vehicle = FU_PREVIEW.instance()
					show_unavailable(true)
				_:
					return
		VehicleSelect.category_names.ROCKET:
			match vehicle:
				0:
					preview_vehicle = WW_PREVIEW.instance()
				1:
					preview_vehicle = TU_PREVIEW.instance()
				2:
					preview_vehicle = EB_PREVIEW.instance()
				_:
					return
		VehicleSelect.category_names.SWITCH:
			match vehicle:
				0:
					preview_vehicle = RE_PREVIEW.instance()
				_:
					return
		VehicleSelect.category_names.BURST:
			match vehicle:
				0:
					preview_vehicle = WR_PREVIEW.instance()
				_:
					return
		VehicleSelect.category_names.OVERCHARGE:
			match vehicle:
				0:
					preview_vehicle = NM_PREVIEW.instance()
				_:
					return
	get_child(3).queue_free()
	add_child(preview_vehicle)
	container.get_node("../StatValues").update_text(preview_vehicle)


func show_unavailable(var b: bool):
	container.show_behind_parent = b
	if b:
		container.modulate = Color(0.2, 0.2, 0.2)
	else:
		container.modulate = Color.white
	unavailable.visible = b
