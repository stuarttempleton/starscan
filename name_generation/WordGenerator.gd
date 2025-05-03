# WordGenerator.gd
extends Node

# Language construct vars
var Languages = {
	"Zerathi": {
		"V": ["a", "e", "i", "o", "u", "ae", "ia", "ei"],
		"C": ["t", "k", "r", "s", "n", "z", "x", "v", "d", "g"],
		"P": ["'", "-"],
		"CharacterPatterns": [
			["CVC", 1.0],
			["CVPCVC", 0.3],
			["CVCVC", 0.8],
			["CVVC", 0.6],
			["CVC-PVC", 0.2]
		]
	},
	"Thraxxian": {
		"V": ["a", "o", "u", "uu", "ao", "oa"],
		"C": ["gr", "kh", "z", "thr", "kr", "gh", "b", "d"],
		"P": ["'", "-"],
		"CharacterPatterns": [
			["CVC", 1.0],
			["CVCVC", 0.7],
			["CVPCCVC", 0.3],
			["CVCC-PVC", 0.2]
		]
	},
	"Aelari": {
		"V": ["e", "i", "ia", "ei", "ae"],
		"C": ["l", "s", "n", "v", "r", "th", "m"],
		"P": ["'", "-"],
		"CharacterPatterns": [
			["VCV", 1.2],
			["CVCV", 0.9],
			["CVPCV", 0.4],
			["VCVCV", 0.8],
			["CVVC-PVC", 0.3]
		]
	}
}

var rng


func get_rng(_seed: int) -> RandomNumberGenerator:
	var new_rng = RandomNumberGenerator.new()
	new_rng.seed = _seed
	return new_rng


func choose_uniform(arr: Array, _rng: RandomNumberGenerator) -> String:
	if arr.empty(): return ""
	return arr[_rng.randi() % arr.size()]


func choose_weighted(patterns: Array, _rng: RandomNumberGenerator) -> String:
	var total_weight = 0.0
	for p in patterns:
		total_weight += p[1]
	var rand = _rng.randf() * total_weight
	var cumulative = 0.0
	for p in patterns:
		cumulative += p[1]
		if rand <= cumulative:
			return p[0]
	return patterns[0][0]


func Create(_seed: int = randi(), language_data = null) -> String:
	var local_rng = get_rng(_seed)
	if language_data == null:
		language_data = Languages["Zerathi"]
	
	var word = generate_word(language_data, local_rng)
	var retries = 5
	while ProfanityFilter.isRestricted(word) and retries > 0:
		word = generate_word(language_data, local_rng)
		retries -= 1
	return word


func generate_word(lang: Dictionary, _rng: RandomNumberGenerator) -> String:
	var structure = choose_weighted(lang["CharacterPatterns"], _rng)
	var word := ""
	for ch in structure:
		match ch:
			"C": word += choose_uniform(lang["C"], _rng)
			"V": word += choose_uniform(lang["V"], _rng)
			"P": word += choose_uniform(lang["P"], _rng)
			_:   word += ch
	return word


func CreateList(_qty, language_data = null):
	var words = []
	for i in _qty:
		words.append(Create(randi(), language_data))
	return words


func RawLetters(qty: int, _seed: int = randi(), language_name: String = "UnknownLanguage") -> String:
	var _rng = get_rng(_seed)
	if not Languages.has(language_name):
		language_name = choose_uniform(Languages.keys(), _rng)

	var lang = Languages[language_name]
	var FullLetterList = lang["V"] + lang["C"]

	var letters := ""
	for i in qty:
		letters += choose_uniform(FullLetterList, _rng)
	return letters
