class_name ScoreboardRecord
extends Reference
# Uses doubly linked list data structure


const MAX_INT := 9_223_372_036_854_775_807

var prev: ScoreboardRecord
var next: ScoreboardRecord
var score: int = 0
var rank: int = 1
var list_position: int = 0
var name: String = ""


func _init(position: int):
	match position:
		0:# For head
			score = MAX_INT
		13:# For tail
			score = -1
			rank = 13


func reward(var amount: int):
	score += amount
	if rank == next.rank:
		next.update_rank_downwards(list_position + 1)
	while score > prev.score:
		move_up()
	if score == prev.score:
		rank = prev.rank
	else:
		rank = list_position
	Global.gameplay_manager.update_scores()


func lose(var amount: int):
	score -= amount
	while score < next.score:
		move_down()
	if score == next.score:
		next.update_rank_downwards(rank)
	Global.gameplay_manager.update_scores()


func move_up():
	prev.next = next
	next = prev
	prev = prev.prev
	next.prev = self
	next.next.prev = next
	prev.next = self
	
	next.list_position += 1
	next.update_rank_downwards(list_position)
	list_position -= 1


func move_down():
	next.prev = prev
	prev = next
	next = next.next
	prev.next = self
	prev.prev.next = prev
	next.prev = self
	
	prev.list_position -= 1
	prev.rank -= 1
	list_position += 1
	rank += 1


func update_rank_downwards(var new_rank: int):
	if score == next.score:
		next.update_rank_downwards(new_rank)
	rank = new_rank


func find_first() -> ScoreboardRecord:
	var return_value: ScoreboardRecord = self
	while return_value.prev.score != MAX_INT:
		return_value = return_value.prev
	return return_value


func append(record: ScoreboardRecord, iteration: int):
	if next == null:
		next = record
		record.list_position = iteration
		record.prev = self
	else:
		next.append(record, iteration + 1)


func to_array() -> Array:
	var return_value: Array = [self]
	var record: ScoreboardRecord = next
	while record.score != -1:
		return_value.append(record)
		record = record.next
	return return_value
