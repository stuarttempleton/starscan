extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
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


func POIStory(POIType, qty):
	#Told when looting a POI
	
	var main_boiler = "[b]%s[/b]\r\n\r\n%s"
	var stats_boiler = "\r\n\r\n[indent][code]%s[/code][/indent]"
	
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
			txt = stat_pos_item_boiler % ["You have gained " + str(qty) + " fuel."]
		"Hazard":
			txt = stat_neg_item_boiler % ["You have lost " + str(qty) + " crew."]
		"Empty":
			txt = stat_pos_item_boiler % ["There is nothing here."]
	
	return txt



# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
