extends Control

func _ready():
	SceneChanger.GoAway()
	GamepadMenu.add_menu(name, $ScenePanel/PanelContainer/HBoxContainer.get_children())

func _exit_tree():
	GamepadMenu.remove_menu(name)

func _on_GenerateArtifacts_pressed():
	var list = ""
	var qty = 10
	var i = 1
	#list += "--. %s\r\n" % [ItemFactory.GenerateItem(ItemFactory.ItemTypes.ARTIFACT, 3729348799).Name]
	
	for w in ItemFactory.GenerateItemList(ItemFactory.ItemTypes.ARTIFACT, qty, {"language_data": LanguageGenerator.generate_language_pack(randi())}):
		list += "%d. %s\r\n" % [i, w.Name]
		i += 1
	$ScenePanel/ContentPanel/VBoxContainer/Name.text = "Artifacts"
	$ScenePanel/ContentPanel/VBoxContainer/Quote.bbcode_text = list


func _on_GenerateSystem_pressed():
	var culture = LanguageGenerator.generate_language_pack(randi())
	var SystemName = WordGenerator.Create(randi(), culture).to_upper()
	var PlanetList = ""
	var planet_qty = randi() % 9
	var i = 1
	for w in WordGenerator.CreateList(planet_qty, culture):
		PlanetList += "%d. %s\r\n" % [i, w.capitalize()]
		i += 1
	$ScenePanel/ContentPanel/VBoxContainer/Name.text = SystemName
	$ScenePanel/ContentPanel/VBoxContainer/Quote.bbcode_text = PlanetList

