extends SubViewport


const ICELAND_POSITION: int = 3
const USA_POSITION: int = 4


func _on_Downpour_focus_entered():
	pass


func _on_TheCalm_focus_entered():
	for n in get_children():
		n.hide()
	$TheCalmCamera.make_current()
	get_child(USA_POSITION).show()
	$TheCalmLight.show()


func _on_Pillars_focus_entered():
	pass


func _on_Sunbreaker_focus_entered():
	pass


func _on_Below_focus_entered():
	for n in get_children():
		n.hide()
	$BelowCamera.make_current()
	get_child(ICELAND_POSITION).show()
	$BelowLight.show()


func _on_Twisted_focus_entered():
	for n in get_children():
		n.hide()
	$TwistedCamera.make_current()
	get_child(USA_POSITION).show()
	$TwistedLight.show()
