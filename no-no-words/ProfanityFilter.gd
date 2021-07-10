extends Node


var NoNoWordFile = "res://no-no-words/no-no-words.json"
var NoNoWords = []


func _ready():
	LoadWords()
#	print("ProfanityFilter: ready")
#	var NoNoTestWords = ["fuck", "ofuck","ofucko","FUCK", "fucck", "fu0ck"]
#	for w in NoNoTestWords:
#		print("Profanity Test: %s - %s" %[w, "restricted" if isRestricted(w.to_lower()) else "safe"])


func LoadWords():
	var _file = File.new()
	_file.open(NoNoWordFile, File.READ)
	var shipdata_json = JSON.parse(_file.get_as_text())
	_file.close()
	NoNoWords = shipdata_json.result


func isRestricted(word):
	for w in NoNoWords:
		if w in word:
			return true
	return false

