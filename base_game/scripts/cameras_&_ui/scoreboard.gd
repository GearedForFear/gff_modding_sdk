extends ColorRect


const Orange := Color("fd5602")

var scoreboard_record: ScoreboardRecord


func update_scores():
	var first: ScoreboardRecord
	var second: ScoreboardRecord
	var third: ScoreboardRecord
	var fourth: ScoreboardRecord

	match scoreboard_record.list_position:
		1:
			get_child(4).modulate = Orange
			get_child(5).modulate = Color.white
			get_child(6).modulate = Color.white
			get_child(7).modulate = Color.white
			first = scoreboard_record
			second = first.next
			third = second.next
			fourth = third.next
		2:
			get_child(4).modulate = Color.white
			get_child(5).modulate = Orange
			get_child(6).modulate = Color.white
			get_child(7).modulate = Color.white
			first = scoreboard_record.prev
			second = scoreboard_record
			third = second.next
			fourth = third.next
		12:
			get_child(4).modulate = Color.white
			get_child(5).modulate = Color.white
			get_child(6).modulate = Color.white
			get_child(7).modulate = Orange
			fourth = scoreboard_record
			third = fourth.prev
			second = third.prev
			first = scoreboard_record.find_first()
		_:
			get_child(4).modulate = Color.white
			get_child(5).modulate = Color.white
			get_child(6).modulate = Orange
			get_child(7).modulate = Color.white
			fourth = scoreboard_record.next
			third = scoreboard_record
			second = third.prev
			first = scoreboard_record.find_first()
	
	get_child(4).text = first.name
	get_child(8).text = String(first.score) + "€"
	get_child(1).text = rank_to_string(second.rank)
	get_child(5).text = second.name
	get_child(9).text = String(second.score) + "€"
	get_child(2).text = rank_to_string(third.rank)
	get_child(6).text = third.name
	get_child(10).text = String(third.score) + "€"
	get_child(3).text = rank_to_string(fourth.rank)
	get_child(7).text = fourth.name
	get_child(11).text = String(fourth.score) + "€"


func rank_to_string(rank: int) -> String:
	match rank:
		1:
			return "1st"
		2:
			return "2nd"
		3:
			return "3rd"
		_:
			return String(rank) + "th"
