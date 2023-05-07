# ArtifactItem
extends BaseItem


# Initialize
func _ready():
	NameGenerator = ArtifactNameGenerator.new()
	NameGenerator.Create()
	
func _generate(_seed:float = randf(), _opts = {}):
	if not _opts.has("rarity"): _opts.rarity = -1
	if not _opts.has("colorize"): _opts.colorize = true
	
	var item = ._generate(_seed)
	item.Name = NameGenerator.Create(_opts.rarity, _opts.colorize)
	item.Type = ItemFactory.ItemTypes.ARTIFACT
	return item
