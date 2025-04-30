extends Control


func update_text(first_record: ScoreboardRecord):
	if first_record.score == first_record.next.score:
		$Headline.text = "Draw"
	else:
		$Headline.text = first_record.name + " Wins"
	var names: Label = $ColorRect/Names
	var scores: Label = $ColorRect/Scores
	names.text = ""
	scores.text = ""
	var records: Array = first_record.to_array()
	for n in records:
		names.text += n.name + "\n"
		scores.text += String(n.score) + "€\n"
	show()
