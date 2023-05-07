# ItemFactory.gd
extends Node


# Types of items that can be generated
enum ItemTypes {BASE, ARTIFACT, RESOURCE, SHIP}


# Generation Functions
func GenerateItem( _type:int = ItemTypes.BASE, _seed:float = randf(), _opts = {}):
	var item
	match _type:
		ItemTypes.SHIP:
			item = $ShipItem._generate(_seed, _opts)
		ItemTypes.ARTIFACT:
			item = $ArtifactItem._generate(_seed, _opts)
		ItemTypes.BASE, _:
			item = $BaseItem._generate(_seed)
	return item

func GenerateItemList(_type:int = ItemTypes.BASE, _qty:int = 5, _opts = {}):
	var items = []
	for i in _qty:
		items.append(GenerateItem(_type, -1, _opts))
	return items
