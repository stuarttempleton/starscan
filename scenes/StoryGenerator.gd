extends Node2D


enum OUTPOST_STATE {LOBBY, FUEL, FUEL_FULL, TURN_IN, TURN_IN_EMPTY}
var main_boiler = "[b]%s[/b]\r\n\r\n%s"
var stats_boiler = "\r\n\r\n[indent][code]%s[/code][/indent]"


func _ready():
	pass # Replace with function body.


func SystemStory(Planet):
	#Told when entering a system.
	#var txt = "[b]A surface encounter...[/b]\r\n\r\n"
#	txt += "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
#	txt += "\r\n\r\n"
#	txt += "[indent][code]"
#	txt += "[color=#00ff00]You found 1 artifact.[/color]\r\n"
#	txt += "[color=#00ff00]You gained 1 fuel.[/color]\r\n"
#	txt += "[color=#ff0000]You lost 10 resources.[/color]\r\n"
#	txt += "[color=#ff0000]You lost half your crew (42 souls).[/color]\r\n"
#	txt += "[/code][/indent]"
#	DisplayText(txt, ["OK"])
	pass


func PlanetStory(Planet):
	#Told when orbiting a planet
	
	#var txt = "[b]A surface encounter...[/b]\r\n\r\n"
#	txt += "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
#	txt += "\r\n\r\n"
#	txt += "[indent][code]"
#	txt += "[color=#00ff00]You found 1 artifact.[/color]\r\n"
#	txt += "[color=#00ff00]You gained 1 fuel.[/color]\r\n"
#	txt += "[color=#ff0000]You lost 10 resources.[/color]\r\n"
#	txt += "[color=#ff0000]You lost half your crew (42 souls).[/color]\r\n"
#	txt += "[/code][/indent]"
#	DisplayText(txt, ["OK"])
	pass

func OutpostStory(_state, planet):
	var title = "Outpost " + planet.Name
	var txt = ""
	
	match _state:
		OUTPOST_STATE.LOBBY:
			txt += "Welcome to the outpost."
		OUTPOST_STATE.FUEL:
			txt += "Refueling... \r\nYour fuel has been replenished."
		OUTPOST_STATE.FUEL_FULL:
			txt += "You do not need fuel."
		OUTPOST_STATE.TURN_IN:
			txt += "Giving your collected artifacts to the academics... \r\n"
			txt += "You have turned in " + str(ShipData.StarShip.DeliveredArtifacts) + " artifacts."
		OUTPOST_STATE.TURN_IN_EMPTY:
			txt += "Giving your collected artifacts to the academics... \r\n"
			txt += "Come back when you have gathered artifacts."
	return main_boiler % [title, txt]


func POIStory(POIType, qty):
	#Told when looting a POI

	var txt = ""
	txt += main_boiler % ["A surface encounter...",_generate_poi_storylet(POIType)]
	txt += stats_boiler % [_poi_item_detail(POIType, qty)]
	
	return txt


func _generate_poi_storylet(POIType):
	var txt = ""
	txt += "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. "
	
	return txt


func _poi_item_detail(POIType, qty):
	
	var stat_pos_item_boiler = "[color=#00ff00]%s[/color]\r\n"
	var stat_neg_item_boiler = "[color=#ff0000]%s[/color]\r\n"
	
	var txt = ""
	
	match POIType:
		"Artifact":
			txt = stat_pos_item_boiler % ["You have found " + str(qty) + " artifact" + str("s" if qty != 1 else '') + "."]
		"Resource":
			txt = stat_pos_item_boiler % ["You have gained " + str(qty) + " resource."]
		"Hazard":
			txt = stat_neg_item_boiler % ["You have lost " + str(qty) + " crew."]
		"Empty":
			txt = stat_pos_item_boiler % ["There is nothing here."]
	
	return txt



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
