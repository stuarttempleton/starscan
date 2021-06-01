extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export(Array, NodePath) var ship_base = []
export(Array, NodePath) var ship_engine = []
export(Array, NodePath) var ship_detail = []
export(Array, NodePath) var ship_paint_base = []
export(Array, NodePath) var ship_paint_detail = []
var rng

var colors = [Color(1.0, 0.0, 0.0, 1.0),
		Color(0.0, 1.0, 0.0, 1.0),
		Color(0.0, 0.0, 1.0, 1.0)]

func _ready():
	ActivateCollections(ship_base)
	ActivateCollections(ship_engine)
	ActivateCollections(ship_detail)
	ActivateCollections(ship_paint_base)
	ActivateCollections(ship_paint_detail)
	if ShipData.StarShip.ShipSeedNumber == 0:
		ShipData.StarShip.ShipSeedNumber = randi()
	_generate(ShipData.StarShip.ShipSeedNumber)


func ActivateCollections(collection):
	for i in range(collection.size()):
		collection[i] = get_node(collection[i])


func TurnOnRandomEntry(collection,random_color = false, random_h_flip = false, qty = 1):
	for item in collection:
		item.hide()
	for i in qty:
		var r = rng.randi_range(0, collection.size()-1)
		if random_color:
			#collection[r].modulate = colors[rng.randi_range(0,colors.size()-1)]
			collection[r].modulate = Color(rng.randf(), rng.randf(), rng.randf(),1.0)
			pass
		if random_h_flip:
			collection[r].set_flip_h(rng.randi_range(0,1) == 1)
		collection[r].show()


func _generate( SeedNumber = -1):
	if SeedNumber < 0: SeedNumber = randi()
	print("Using seed number: ", SeedNumber)
	rng = RandomNumberGenerator.new()
	rng.seed = SeedNumber
	
	TurnOnRandomEntry(ship_base)
	TurnOnRandomEntry(ship_engine)
	TurnOnRandomEntry(ship_detail)
	TurnOnRandomEntry(ship_paint_base, true, true)
	TurnOnRandomEntry(ship_paint_detail, true, true, rng.randi_range(1,2))


func _on_Button_toggled(button_pressed):
	print("Generating new ship")
	_generate(-1)
