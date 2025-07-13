extends Node


# Core Stat and Attribute list
var statributes = {
		"FuelCapacity": {
			"Name": "Fuel Capacity",
			"value": 1,
			"chance": 0.7,
			"range": {"min": 0, "max": 1000}
		},
		"FuelEfficiency": {
			"Name": "Fuel Efficiency",
			"value": 2,
			"chance": 0.7,
			"range": {"min": 0.0, "max": 1.0}
		}
	}


func get_rng(_seed: int) -> RandomNumberGenerator:
	var new_rng = RandomNumberGenerator.new()
	new_rng.seed = _seed
	return new_rng


# Determine if data being passed around is float by checking template
func is_float_stat(stat_key: String) -> bool:
	var template = statributes[stat_key]
	var min_val = template["range"]["min"]
	var max_val = template["range"]["max"]
	return typeof(min_val) == TYPE_REAL or typeof(max_val) == TYPE_REAL
	
	
# Utility overload to generate item from seed
func generate_from_item(_item):
	return generate(_item.Seed, _item.Rarity)
	
	
# Create based off of a specific seed, e.g. item seed or ship seed
func generate(_seed: int = randi(), _rarity: float = 0) -> Dictionary:
	var rng = get_rng(_seed)
	# If we don't have a rarity, try to regenerate it
	if _rarity == 0:
		var temp_item = ItemFactory.GenerateItem(ItemFactory.ItemTypes.ARTIFACT, _seed)
		if temp_item and temp_item.has("Rarity"):
			_rarity = temp_item.Rarity
		else:
			_rarity = 0.5  # Sane default
	var stat_block = {}

	for stat in statributes.keys():
		var template = statributes[stat]
		var chance = template["chance"] if template.has("chance") else 0.8
		if rng.randf() > (1.0 - chance):
			var new_entry = template.duplicate(true)
			var min_val = template["range"]["min"]
			var max_val = template["range"]["max"]
			var is_float = is_float_stat(stat)
			var rarity_scale = clamp(_rarity, 0.0, 1.0)

			var value = 0
			if is_float:
				value = rng.randf_range(min_val, max_val) * rarity_scale
			else:
				value = rng.randi_range(int(min_val), int(max_val)) * rarity_scale

			new_entry["is_debuff"] = rng.randf() < 0.2
			new_entry["value"] = -abs(value) if new_entry["is_debuff"] else abs(value)
			
			stat_block[stat] = new_entry
	return stat_block


# return a list of collective stat bonuses from an array of stat blocks
func combine(stat_blocks: Array):
	var combined_block = {}
	for stat_block in stat_blocks:
		for stat in stat_block.keys():
			if combined_block.has(stat):
				combined_block[stat]["value"] += stat_block[stat]["value"]
			else:
				combined_block[stat] = stat_block[stat].duplicate(true)
	return combined_block


# Player facing strings
# Generates individual stat strings
func generate_stat_string(stat_key: String, stat: Dictionary) -> String:
	var is_float = is_float_stat(stat_key)
	var boiler_plate = "%s%.2f %s" if is_float else "%s%d %s"
	var stat_text = boiler_plate % ["-" if stat["is_debuff"] else "+", abs(stat["value"]), stat["Name"]]
	return stat_text


# Generates strings for full stat blocks
func generate_stat_block_string(stat_block: Dictionary = {}):
	var stat_list = []
	if stat_block.size() > 0:
		for stat in stat_block.keys():
			stat_list.append(generate_stat_string(stat, stat_block[stat]))
	return ", ".join(stat_list)
