extends Control

func _ready():
	var number = 5
	var snumb = "%02d" % number
	
	
	var currtime = OS.get_datetime()
	
	var filename = "user://Starmap_%04d-%02d-%02d_%02d-%02d-%02d_%s.json" % [currtime.year, currtime.month, currtime.day, currtime.hour, currtime.minute, currtime.second, "rng"]
	
	print(filename)

func _on_GenerateArtifacts_pressed():
	var list = ""
	var qty = 10 #$WordGenerator.NewRand(8) + 1
	var i = 1
	for w in $WordGenerator/Artifact.CreateList(qty, true):
		list += "%d. %s\r\n" % [i, w]
		i += 1
	$VBoxContainer/Name.text = "Artifacts"
	$VBoxContainer/Quote.bbcode_text = list


func _on_GenerateSystem_pressed():
	var SystemName = $WordGenerator.CreateWord().to_upper()
	var PlanetList = ""
	var planet_qty = $WordGenerator.NewRand(8) + 1
	var i = 1
	for w in $WordGenerator.CreateWordList(planet_qty):
		PlanetList += "%d. %s\r\n" % [i, w.capitalize()]
		i += 1
	$VBoxContainer/Name.text = SystemName
	$VBoxContainer/Quote.bbcode_text = PlanetList
