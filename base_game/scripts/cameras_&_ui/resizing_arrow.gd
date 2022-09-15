extends Polygon2D


onready var base_polygon = polygon


func _ready():
	var new_polygon: PoolVector2Array = PoolVector2Array()
	for n in base_polygon:
		new_polygon.append(n * OS.window_size.y / 360 \
				/ get_node("/root/RootControl/SettingsManager").resolution \
				/ get_node("/root/RootControl/SettingsManager")\
				.split_screen_divisor)
	polygon = new_polygon
