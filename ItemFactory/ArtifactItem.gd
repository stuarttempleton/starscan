# ArtifactItem
extends BaseItem


# Initialize
func _ready():
	NameGenerator = ArtifactNameGenerator.new()
	
func _generate(_seed:int = randi(), _opts = {}):
	var rng = RandomNumberGenerator.new()
	rng.seed = _seed
	
	if not _opts.has("colorize"): _opts.colorize = true
	
	var item = ._generate(_seed)
	item.Rarity = rng.randf()
	item.Name = NameGenerator.Create(_seed, item.Rarity, _opts.colorize)
	item.Type = ItemFactory.ItemTypes.ARTIFACT
	return item
