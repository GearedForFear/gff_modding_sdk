extends GlobalAudioPlayer


export var starts: PoolRealArray

var last_played: int = 0
var just_started := false


func try_play():
	if just_started:
		return
	play(random_start())
	just_started = true
	$Duration.start()
	$MinimumDuration.start()


func random_start() -> float:
	var random: int = randi() % starts.size()
	if random == last_played:
		random = (random + 1) % starts.size()
	last_played = random
	return starts[random]


func _on_Duration_timeout():
	stop()


func _on_MinimumDuration_timeout():
	just_started = false
