extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var noise
var map_size = Vector2(120,60)

# tilemap_node, tilemap cell, noise threshold, randi() noise
#export var meta_data = [
#	["MapLayer1", 0, 1, false],
#	["MapLayer2", 7, 0.8, false],
#	["MapLayer3", 1, -0.1, false],
#	["MapLayer4", 2, 0.2, false],
#	["MapLayer5", 3, -0.2, false],
#	["MapLayer6", 4, -0.22, false],
#	["MapLayer7", 5, -0.24, false],
#	["MapLayer8", 6, 0.2, true],
#	["MapLayer9", 6, 0.2, true]
#	]
var planetary_meta_data = { 
	"Gas":[
		["MapLayer1", 0, 1, true],
		["MapLayer2", 3, 0.8, false],
		["MapLayer3", 1, -0.1, false],
		["MapLayer4", 2, 0.2, false],
		["MapLayer5", 12, -0.2, false],
		["MapLayer6", 6, -0.22, false],
		["MapLayer7", 6, -0.24, false],
		["MapLayer8", 3, 0.2, true],
		["MapLayer9", 0, 0.2, true]],
	"Ice":[
		["MapLayer1", 6, 1, false],
		["MapLayer2", 6, 0.8, false],
		["MapLayer3", 6, -0.1, false],
		["MapLayer4", 6, 0.2, false],
		["MapLayer5", 6, -0.2, false],
		["MapLayer6", 1, -0.22, false],
		["MapLayer7", 6, -0.24, false],
		["MapLayer8", 6, 0.2, true],
		["MapLayer9", 6, 0.2, true]],
	"Lava":[
		["MapLayer1", 8, 1, false],
		["MapLayer2", 9, 0.8, false],
		["MapLayer3", 11, -0.1, false],
		["MapLayer4", 11, 0.2, false],
		["MapLayer5", 9, -0.2, false],
		["MapLayer6", 9, -0.22, false],
		["MapLayer7", 10, -0.24, false],
		["MapLayer8", 10, 0.2, true],
		["MapLayer9", 10, 0.2, true]],
	"Goldilocks":[
		["MapLayer1", 0, 1, false],
		["MapLayer2", 7, 0.8, false],
		["MapLayer3", 1, -0.1, false],
		["MapLayer4", 2, 0.2, false],
		["MapLayer5", 3, -0.2, false],
		["MapLayer6", 4, -0.22, false],
		["MapLayer7", 5, -0.24, false],
		["MapLayer8", 6, 0.2, true],
		["MapLayer9", 6, 0.2, true]],
	"Desert":[
		["MapLayer1", 3, 1, false],
		["MapLayer2", 3, 0.8, false],
		["MapLayer3", 1, -0.1, false],
		["MapLayer4", 2, 0.2, false],
		["MapLayer5", 3, -0.2, false],
		["MapLayer6", 2, -0.22, false],
		["MapLayer7", 2, -0.24, false],
		["MapLayer8", 3, 0.2, true],
		["MapLayer9", 6, 0.2, true]],
	"Ocean":[
		["MapLayer1", 0, 1, false],
		["MapLayer2", 1, 0.8, false],
		["MapLayer3", 6, -0.1, false],
		["MapLayer4", 1, 0.2, false],
		["MapLayer5", 6, -0.2, false],
		["MapLayer6", 1, -0.22, false],
		["MapLayer7", 1, -0.24, true],
		["MapLayer8", 6, 0.2, true],
		["MapLayer9", 6, 0.2, true]],
	"Asteroid Belt":[
		["MapLayer1", 14, 1, false],
		["MapLayer2", 14, 0.8, false],
		["MapLayer3", 14, -0.1, false],
		["MapLayer4", 6, -0.5, true],
		["MapLayer5", 13, -0.22, false],
		["MapLayer6", 13, -0.24, false],
		["MapLayer7", 12, -0.4, false],
		["MapLayer8", 6, -1, true],
		["MapLayer9", 14, 0.2, true]],
	"Comet":[
		["MapLayer1", 13, 1, false],
		["MapLayer2", 13, 0.8, false],
		["MapLayer3", 13, -0.1, false],
		["MapLayer4", 6, -0.5, true],
		["MapLayer5", 13, -0.22, false],
		["MapLayer6", 12, -0.26, false],
		["MapLayer7", 6, -0.5, false],
		["MapLayer8", 6, -0.8, true],
		["MapLayer9", 14, 0.2, true]],
	"Outpost":[
		["MapLayer1", 0, 1, false],
		["MapLayer2", 7, 0.8, false],
		["MapLayer3", 1, -0.1, false],
		["MapLayer4", 2, 0.2, false],
		["MapLayer5", 3, -0.2, false],
		["MapLayer6", 4, -0.22, false],
		["MapLayer7", 5, -0.24, false],
		["MapLayer8", 6, 0.2, true],
		["MapLayer9", 6, 0.2, true]],
	}

var planet

# Called when the node enters the scene tree for the first time.
func _ready():
	# start centered
	var mapX = get_viewport().get_visible_rect().size.x/2
	var mapY = get_viewport().get_visible_rect().size.y/2
	
	# apply offset based on map size.
	mapX -= map_size.x / 2 * ($MapLayer1.cell_size.x * scale.x)
	mapY -= map_size.y / 2 * ($MapLayer1.cell_size.y * scale.y)
	
	# apply adjustment for scale changes
	#mapX *= (1 / scale.x)
	#mapY *= (1 / scale.y)
	
	var center = Vector2(mapX, mapY)
	position = center
	
	print(center)
	pass


func _generate(_planet):
	planet = _planet
	make_some_noise(planet.SurfaceSeednumber)
	for layer_meta in planetary_meta_data[planet.Type]:
		make_map_layer(layer_meta)


func make_some_noise(seednumber):
	#randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = seednumber
	noise.octaves = 3
	noise.period = 24


func make_map_layer(layer_meta):
	get_node(layer_meta[0]).clear()
	if (layer_meta[3]):
		randomize()
		make_some_noise(randi()%2147483645 + 1)
	for x in map_size.x:
		for y in map_size.y:
			var a = noise.get_noise_2d(x,y)
			if layer_meta[2] > a:
				get_node(layer_meta[0]).set_cell(x,y,layer_meta[1])
	get_node(layer_meta[0]).update_bitmask_region(Vector2(0,0), map_size)
