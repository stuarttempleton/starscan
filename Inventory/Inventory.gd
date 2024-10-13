extends CanvasLayer


# Inventory UI based vars
var Ship
var DescBoilerPlate = "Captain, these are the contents of the ship's cargo bay. [color=yellow]%d / %d artifacts delivered.[/color]"


# Inventory-UI
func _ready():
	Ship = ShipData.Ship()
	SceneChanger.GoAway()
	GamepadMenu.add_menu(name, $InventoryUI/ButtonContainer/HBoxContainer.get_children())
	# warning-ignore:return_value_discarded
	GameController.connect("inventory_state", self, "ShowInventory")
	$InventoryUI/CargoContainer/VBoxContainer/ScrollContainer/ItemList.connect("item_list_changed",self,"BuildInventory")
	ShowInventory(false)


func ShowInventory(state:bool=true):
	if state:
		MovementEvent.add_deadzone(name, $InventoryUI.get_global_rect())
		BuildInventory()
	else:
		MovementEvent.remove_deadzone(name)
		GamepadMenu.remove_menu(name)
	$InventoryUI.visible = state
	$BlurBackground.visible = state
	
	
func BuildInventory(_qty = 0):
	# Clear existing stuff
	$InventoryUI/CargoContainer/VBoxContainer/ScrollContainer/ItemList.ClearList()
	
	#Update the UI text
	UpdateBoilerText()
	
	# Populate with ship inventory
	for item in ShipData.GetInventoryFor(ItemFactory.ItemTypes.ARTIFACT):
		AddInventory(item)

	# Update buttons
	var buttons:Array = []
	buttons.append_array($InventoryUI/CargoContainer/VBoxContainer/ScrollContainer/ItemList.GetButtons())
	for button in $InventoryUI/ButtonContainer/HBoxContainer.get_children():
		if button.visible:
			buttons.append(button)
	
	# Either focus on the first item or the the removed item -1
	var button_selected = max(0, GamepadMenu.get_cursor(name) - 1)
	
	# Remove the menu buttons, then re-add the new list
	GamepadMenu.remove_menu(name)
	GamepadMenu.add_menu(name, buttons, button_selected)


func AddInventory(_item):
	$InventoryUI/CargoContainer/VBoxContainer/ScrollContainer/ItemList.LoadItem(_item, ItemUI_element.CONTEXT.DESTROY)

func UpdateBoilerText():
	$InventoryUI/CargoContainer/VBoxContainer/ContainerDescription.bbcode_text = DescBoilerPlate % [ShipData.StarShip.DeliveredArtifacts, $"/root/GameController/WinLoseCheck".ArtifactsRequiredToWin]

func PopulateFakeInventory(_qty:int = 5):
	ShipData.AddItemListToInventory(ItemFactory.GenerateItemList(ItemFactory.ItemTypes.ARTIFACT,10))

func _on_AddItem_pressed():
	PopulateFakeInventory()
	ShowInventory()

func _on_Discard_pressed():
	$InventoryUI/CargoContainer/VBoxContainer/ScrollContainer/ItemList.DiscardAllByRarity(0.5)


func _on_Done_pressed():
	GameController.InventoryToggle()
