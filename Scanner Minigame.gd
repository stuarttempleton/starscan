extends Node

export(NodePath) var oscillator_path
var oscillator

export var speed = 0.5
export var greenMin = 0.4
export var greenMax = 0.6
var x = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	oscillator = get_node(oscillator_path)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	x = fmod(x + delta * speed, 2.0)
	oscillator.targetT = abs(x - 1.0)

