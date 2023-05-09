extends HBoxContainer


var lastpeek
export(ItemFactory.ItemTypes) var inventory_type_key

var boiler_plate = "x %s"

func _ready():
	SetQTY(1.0)

func SetQTY(qty) :
	lastpeek = qty
	$QTY.text = boiler_plate % [str(qty)]

func _process(_delta):
	var qty = ShipData.GetInventoryQTYFor(inventory_type_key)
	if (qty != lastpeek) :
		SetQTY(qty)
	if (qty > 0) :
		$QTY.show()
		$Icon.show()
	else :
		$QTY.hide()
		$Icon.hide()
