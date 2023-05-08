# ShipItem.gd
extends BaseItem

# Ship specific vars
var Vessel = {	
	"Friendly":[
		"Rescue",
		"Reconnaissance",
		"Recon",
		"Surveillance",
		"Scientific",
		"Search",
		"Scan",
		"Survey",
		"Exploration",
		"Experimental",
		"Diplomatic"
		], 
	"Hostile":[
		"Privateer",
		"Raider",
		"Corsair",
		"Marauder",
		"Pirate",
		"Liberated",
		"Ex-Colony",
		"Buccaneer"
	]}


# Ship generation override
func _generate(_seed:int = randi(), _opts = {}):
	var rng = RandomNumberGenerator.new()
	rng.seed = _seed
	
	if not _opts.has("disposition"): _opts.disposition = false
	_opts.disposition = "Friendly" if _opts.disposition else "Hostile"
	
	var item = ._generate(_seed)
	item.Name = NameGenerator.Create(_seed)
	item.Type = ItemFactory.ItemTypes.SHIP
	item.Captain = NameGenerator.Create(_seed).capitalize()
	item.Disposition = Vessel[_opts.disposition][rng.randi() % Vessel[_opts.disposition].size()-1]
	item.Designation = str(1000 + rng.randi() % 8000)
	item.FullDesignation = "%s-%s-%s" % [
		item.Disposition.left(3).trim_suffix("-").to_upper(),
		item.Designation,
		WordGenerator.RawLetters(1).to_upper()
		]
	
#	var Ship = {
#		"Captain" : WordGenerator.Create().capitalize(),
#		"Name" : WordGenerator.Create().capitalize(),
#		"Disposition" : Vessel[disposition][randi() % Vessel[disposition].size()-1],
#		"Designation" : str(1000 + randi() % 8000),
#		"FullDesignation" : ""
#		}
#
#	Ship["FullDesignation"] = "%s-%s-%s" % [
#		Ship.Disposition.left(3).trim_suffix("-").to_upper(),
#		Ship.Designation,
#		WordGenerator.RawLetters(1).to_upper()
#		]
		
	return item
