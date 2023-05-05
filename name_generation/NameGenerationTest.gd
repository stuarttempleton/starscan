extends Control

func _ready():
	SceneChanger.GoAway()
	GamepadMenu.add_menu(name, $ScenePanel/PanelContainer/HBoxContainer.get_children())

func _exit_tree():
	GamepadMenu.remove_menu(name)

func _on_GenerateArtifacts_pressed():
	var list = ""
	var qty = 10 #$WordGenerator.NewRand(8) + 1
	var i = 1
	for w in $WordGenerator/Artifact.CreateList(qty, true):
		list += "%d. %s\r\n" % [i, w]
		i += 1
	$ScenePanel/ContentPanel/VBoxContainer/Name.text = "Artifacts"
	$ScenePanel/ContentPanel/VBoxContainer/Quote.text = list


func _on_GenerateSystem_pressed():
	var SystemName = $WordGenerator.CreateWord().to_upper()
	var PlanetList = ""
	var planet_qty = $WordGenerator.NewRand(8) + 1
	var i = 1
	for w in $WordGenerator.CreateWordList(planet_qty):
		PlanetList += "%d. %s\r\n" % [i, w.capitalize()]
		i += 1
	$ScenePanel/ContentPanel/VBoxContainer/Name.text = SystemName
	$ScenePanel/ContentPanel/VBoxContainer/Quote.text = PlanetList
