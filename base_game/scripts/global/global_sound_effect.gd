extends GlobalAudioPlayer


export var starts: PoolRealArray

var last_played: int = 0


func try_play():
	play(random_start())
	$Timer.start()


func random_start() -> float:
	var random: int = randi() % starts.size()
	if random == last_played:
		random = (random + 1) % starts.size()
	last_played = random
	return starts[random]


func _on_Timer_timeout():
	stop()
