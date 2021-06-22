extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	#for i in 10:
	#	GenerateNPCShip(true if randi()%2>0 else false)
	pass # Replace with function body.


func GenerateNPCShip(disposition):
	disposition = "Friendly" if disposition else "Hostile"
	var Vessel = {	"Friendly":[
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
	var wordgen = get_parent()
	randi() % Vessel.Friendly.size()-1

	var Ship = {
		"Captain" : wordgen.CreateWord().capitalize(),
		"Name" : wordgen.CreateWord().capitalize(),
		"Disposition" : Vessel[disposition][randi() % Vessel[disposition].size()-1],
		"Designation" : str(1000 + randi() % 8000),
		"FullDesignation" : ""
		}
		
	Ship["FullDesignation"] = "%s-%s-%s" % [Ship.Disposition.left(3).trim_suffix("-").to_upper(),Ship.Designation,wordgen.RawLetters(1).to_upper()]
		
	print("Captain %s of %s Vessel %s" % [Ship.Captain, Ship.Disposition, Ship.FullDesignation])
	return Ship
