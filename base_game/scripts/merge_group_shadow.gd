extends Spatial


enum shadow_casters {EXTRA_LOW, LOW, DEFAULT, HIGH, EXTRA_HIGH, ULTIMATE}

export(shadow_casters) var required_setting: int = shadow_casters.DEFAULT


func _ready():
	if get_node("/root/RootControl/SettingsManager").shadow_casters \
			< required_setting:
		$"Shadow [MergeGroup]".hide()
