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
	ShowInventory(false)

func ShowInventory(state:bool=true):
	# Clear existing stuff
	$InventoryUI/CargoContainer/VBoxContainer/ScrollContainer/ItemList.ClearList()
	if state:
		UpdateBoilerText()
		# Populate with ship inventory
		for item in ShipData.GetInventoryFor(ItemFactory.ItemTypes.ARTIFACT):
			AddInventory(item)
	
	# Set the whole thing to visible=state.
	$InventoryUI.visible = state
	$BlurBackground.visible = state
	# Set game state
	pass

func AddInventory(_item):
	$InventoryUI/CargoContainer/VBoxContainer/ScrollContainer/ItemList.LoadItem(_item)

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
