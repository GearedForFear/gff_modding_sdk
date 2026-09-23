extends AspectRatioContainer


const EXTERIORS_2D: Array2dResource = preload(
		"res://resources/custom/skins/exteriors.tres")
const POSITION := PoolByteArray([0, 0])

export var options_horizontal := Array()
export var options_vertical := Array()

var original_skin: VehicleSkin
var edited_skin: VehicleSkin


func _process(_delta):
	if Input.is_action_just_pressed("ui_left"):
		move_horizontal(-1)
	elif Input.is_action_just_pressed("ui_right"):
		move_horizontal(1)
	
	if Input.is_action_just_pressed("ui_up"):
		move_vertical(-1)
	elif Input.is_action_just_pressed("ui_down"):
		move_vertical(1)


func set_skin(skin: VehicleSkin):
	original_skin = skin
	edited_skin = skin.duplicate()


func move_horizontal(direction: int):
	var position_h: int = POSITION[0]
	position_h += direction
	
	if EXTERIORS_2D.is_out_of_horizontal_bounds(position_h):
		return
	
	POSITION[0] = position_h


func move_vertical(direction: int):
	pass
