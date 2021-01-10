extends Control

export var maxSize = 1.0
export var targetT = 0.0

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


func _process(delta):
	self.rect_size.x = maxSize * targetT
