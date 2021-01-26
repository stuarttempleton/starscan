extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var noise
var map_size = Vector2(120,60)

# tilemap_nod, tilemap cell, noise threshold, start new noise
export var meta_data = [
	["MapLayer1", 0, 1, false],
	["MapLayer2", 7, 0.8, false],
	["MapLayer3", 1, -0.1, false],
	["MapLayer4", 2, 0.2, false],
	["MapLayer5", 3, -0.2, false],
	["MapLayer6", 4, -0.22, false],
	["MapLayer7", 5, -0.24, false],
	["MapLayer8", 6, 0.2, true],
	["MapLayer9", 6, 0.2, true]
	]
var planetary_meta_data = { 
	"Gas":[
		["MapLayer1", 0, 1, false],
		["MapLayer2", 7, 0.8, false],
		["MapLayer3", 1, -0.1, false],
		["MapLayer4", 2, 0.2, false],
		["MapLayer5", 3, -0.2, false],
		["MapLayer6", 4, -0.22, false],
		["MapLayer7", 5, -0.24, false],
		["MapLayer8", 6, 0.2, true],
		["MapLayer9", 6, 0.2, true]],
	"Ice":[
		["MapLayer1", 0, 1, false],
		["MapLayer2", 7, 0.8, false],
		["MapLayer3", 1, -0.1, false],
		["MapLayer4", 2, 0.2, false],
		["MapLayer5", 3, -0.2, false],
		["MapLayer6", 4, -0.22, false],
		["MapLayer7", 5, -0.24, false],
		["MapLayer8", 6, 0.2, true],
		["MapLayer9", 6, 0.2, true]],
	"Lava":[
		["MapLayer1", 0, 1, false],
		["MapLayer2", 7, 0.8, false],
		["MapLayer3", 1, -0.1, false],
		["MapLayer4", 2, 0.2, false],
		["MapLayer5", 3, -0.2, false],
		["MapLayer6", 4, -0.22, false],
		["MapLayer7", 5, -0.24, false],
		["MapLayer8", 6, 0.2, true],
		["MapLayer9", 6, 0.2, true]],
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
		["MapLayer1", 0, 1, false],
		["MapLayer2", 7, 0.8, false],
		["MapLayer3", 1, -0.1, false],
		["MapLayer4", 2, 0.2, false],
		["MapLayer5", 3, -0.2, false],
		["MapLayer6", 4, -0.22, false],
		["MapLayer7", 5, -0.24, false],
		["MapLayer8", 6, 0.2, true],
		["MapLayer9", 6, 0.2, true]],
	"Ocean":[
		["MapLayer1", 0, 1, false],
		["MapLayer2", 7, 0.8, false],
		["MapLayer3", 1, -0.1, false],
		["MapLayer4", 2, 0.2, false],
		["MapLayer5", 3, -0.2, false],
		["MapLayer6", 4, -0.22, false],
		["MapLayer7", 5, -0.24, false],
		["MapLayer8", 6, 0.2, true],
		["MapLayer9", 6, 0.2, true]],
	"Asteroid Belt":[
		["MapLayer1", 0, 1, false],
		["MapLayer2", 7, 0.8, false],
		["MapLayer3", 1, -0.1, false],
		["MapLayer4", 2, 0.2, false],
		["MapLayer5", 3, -0.2, false],
		["MapLayer6", 4, -0.22, false],
		["MapLayer7", 5, -0.24, false],
		["MapLayer8", 6, 0.2, true],
		["MapLayer9", 6, 0.2, true]],
	"Comet":[
		["MapLayer1", 0, 1, false],
		["MapLayer2", 7, 0.8, false],
		["MapLayer3", 1, -0.1, false],
		["MapLayer4", 2, 0.2, false],
		["MapLayer5", 3, -0.2, false],
		["MapLayer6", 4, -0.22, false],
		["MapLayer7", 5, -0.24, false],
		["MapLayer8", 6, 0.2, true],
		["MapLayer9", 6, 0.2, true]],
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
	
# Called when the node enters the scene tree for the first time.
func _ready():
	_generate("Goldilocks")
	
func _generate(planet_type):
	make_some_noise()
	for layer_meta in planetary_meta_data[planet_type]:
		make_map_layer(layer_meta)
		
func make_some_noise():
	randomize()
	noise = OpenSimplexNoise.new()
	noise.seed = randi()
	noise.octaves = 3
	noise.period = 24
	
func make_map_layer(layer_meta):
	get_node(layer_meta[0]).clear()
	if (layer_meta[3]):
		make_some_noise()
		
	for x in map_size.x:
		for y in map_size.y:
			var a = noise.get_noise_2d(x,y)
			if layer_meta[2] > a:
				get_node(layer_meta[0]).set_cell(x,y,layer_meta[1])
	get_node(layer_meta[0]).update_bitmask_region(Vector2(0,0), map_size)

# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass
