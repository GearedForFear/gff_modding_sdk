extends Label


const smaller_font: DynamicFont\
		= preload("res://resources/fonts/lacquer_14.tres")


func _ready():
	_draw()


func _draw():
	if get_total_character_count() > 70:
		add_font_override("font", smaller_font)
