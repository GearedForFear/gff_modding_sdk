class_name VehicleList
extends Resource


enum CategoryNames {GAMEPLAY, PREVIEW}

const VEHICLES: Dictionary = {
	"Chain's Awe": "chains_awe",
	"Suicide Door": "suicide_door",
	"Grave Mistake": "grave_mistake",
	"Metal Undertow": "metal_undertow",
	"Fungibber": "fungibber",
	"Warm Welcome": "warm_welcome",
	"Turbulence": "turbulence",
	"Eternal Bond": "eternal_bond",
	"Missilodon": "missilodon",
	"Restless": "restless",
	"Well Raised": "well_raised",
	"No Match": "no_match"
}


func get_scene(key: String, category: int) -> Resource:
	var unique_section_in_path: String
	if key == "":
		unique_section_in_path = Utils.random_dictionary_value(VEHICLES)
	else:
		unique_section_in_path = VEHICLES.get(key)
	
	var path: String
	match category:
		CategoryNames.GAMEPLAY:
			path = playable_path(unique_section_in_path)
		CategoryNames.PREVIEW:
			path = preview_path(unique_section_in_path)
	return ResourceLoader.load(path, "PackedScene")


func get_scene_random(category: int) -> Resource:
	return get_scene("", category)


func playable_path(unique_section: String) -> String:
	return "res://scenes/vehicles/" + unique_section + ".tscn"


func preview_path(unique_section: String) -> String:
	return "res://scenes/vehicles/preview/" + unique_section + "_preview.tscn"
