extends Node


var Patterns = ["%name's %noun", "%noun of %name", "The %name %noun", "%name %noun"]
var Nouns = ["Hammer"]


func ExpandPattern(pat):
	return pat.replace("%name", get_parent().CreateWord().capitalize()).replace("%noun", Nouns[NewRand(Nouns.size())].capitalize())


func Create():
	return ExpandPattern( Patterns[NewRand(Patterns.size())] )


func NewRand(_max):
	randomize()
	return randi() % _max # int(rand_range(0, _max))

func CreateList(_qty):
	var items = []
	for i in _qty:
		items.append(Create())
	return items
