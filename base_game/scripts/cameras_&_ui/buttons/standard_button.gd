class_name StandardButton
extends Button


export var autograb := false


func _enter_tree():
	if autograb:
		grab_focus()


func _pressed():
	GlobalAudio.play("ButtonPressAudio")
	MenuManager.go_to(name)
