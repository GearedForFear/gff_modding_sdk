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


func _process(_delta):
	var vehicle: CombatVehicle = get_node("../../../../../../..")
	if vehicle.alive:
		var direction: Vector3 = vehicle.global_transform.origin.direction_to(\
				vehicle.target.global_transform.origin)
		transform.x = Vector2(direction.z, -direction.x).normalized()
		transform.y = Vector2(direction.x, direction.z).normalized()
		rotation += get_node("../../../../..").rotation.y + PI
