extends Node


func generate_culture_name(language_data: Dictionary, seed_offset: int = 0) -> String:
	var rng = RandomNumberGenerator.new()
	rng.seed = language_data.get("Seed", randi()) + seed_offset

	var structure = WordGenerator.choose_weighted(language_data["CharacterPatterns"], rng)
	var name := ""
	for ch in structure:
		match ch:
			"C": name += WordGenerator.choose_uniform(language_data["C"], rng)
			"V": name += WordGenerator.choose_uniform(language_data["V"], rng)
			"P": name += WordGenerator.choose_uniform(language_data["P"], rng)
			_:   name += ch

	# Optional: Capitalize the first letter
	if name.length() > 0:
		name = name[0].to_upper() + name.substr(1)

	return name


func generate_language_pack(_seed: int) -> Dictionary:
	var rng = RandomNumberGenerator.new()
	rng.seed = _seed

	var all_vowels = ["a", "e", "i", "o", "u", "ae", "ia", "ei", "ao", "oo", "uu"]
	var all_consonants = ["b","c","d","f","g","h","j","k","l","m","n","p","q","r","s","t","v","w","x","y","z",
						  "gr", "kr", "th", "sh", "zh", "vr", "sk", "tz"]
	var all_punctuation = ["'", "-", "."]

	var vowels = []
	var consonants = []
	var punctuation = []
	var patterns = []

	for i in range(rng.randi_range(4, 8)):
		vowels.append(all_vowels[rng.randi_range(0, all_vowels.size() - 1)])

	for i in range(rng.randi_range(6, 12)):
		consonants.append(all_consonants[rng.randi_range(0, all_consonants.size() - 1)])

	for i in range(rng.randi_range(0, 2)):
		punctuation.append(all_punctuation[rng.randi_range(0, all_punctuation.size() - 1)])

	var pattern_templates = [
		["CVC", 1.0],
		["CVVC", 0.6],
		["CVCVC", 0.8],
		["CVPCVC", 0.3],
		["VCV", 1.0],
		["CVC-CVC", 0.2]
	]

	var available = pattern_templates.duplicate()
	for i in range(rng.randi_range(2, 5)):
		var index = rng.randi_range(0, available.size() - 1)
		patterns.append(available[index])
		available.remove(index)

	var lang = {
		"V": vowels,
		"C": consonants,
		"P": punctuation,
		"CharacterPatterns": patterns,
		"Seed": _seed
	}

	lang["Name"] = generate_culture_name(lang)
	return lang

