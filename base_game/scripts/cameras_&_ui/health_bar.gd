extends ProgressBar


export var update_value: bool = true


func _ready():
	if update_value:
		max_value = get_node("../../../../../..").base_health


func _physics_process(_delta):
	if update_value:
		value = get_node("../../../../../..").health
	if value == max_value:
		modulate = Color(1, 1, 1, 0.5)
	else:
		modulate = Color(1, 1, 1, 1)
