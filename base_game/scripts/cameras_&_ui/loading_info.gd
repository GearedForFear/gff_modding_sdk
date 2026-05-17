extends Label


var remaining_materials: int = 0
var remaining_deletions: int = 0
var one_hundred_percent: int = 0


func _ready():
	Precompiler.get_this().connect("start", self, "start_materials")
	DeletionManager.get_this().connect("start", self, "start_deleting")


func _process(delta):
	if one_hundred_percent <= 0:
		set_process(false)
		return
	
	text = ""
	if remaining_materials >= 0:
		text += "Preparing shaders\n"
	if remaining_deletions >= 0:
		text += "Freeing up memory\n"
	if remaining_materials > 0 and remaining_deletions > 0:
		text += "\n"
	text += "Progress: "
	var remaining_frames: int = max(remaining_materials, remaining_deletions)
	var progress: float \
			= (1.0 - float(remaining_frames) / one_hundred_percent) * 100
	text += String(stepify(progress, 0.01))
	text += "%"
	
	if remaining_materials <= 0 and remaining_deletions <= 0:
		one_hundred_percent = 0
		set_process(false)
		hide()
	remaining_materials -= 1
	remaining_deletions -= 1


func start_materials(materials_size):
	remaining_materials = materials_size
	start(materials_size)


func start_deleting(new_remaining_deletions):
	remaining_deletions = new_remaining_deletions
	start(new_remaining_deletions)


func start(new_one_hundred_percent):
	set_process(true)
	show()
	one_hundred_percent = max(one_hundred_percent, new_one_hundred_percent)
