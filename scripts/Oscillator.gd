extends Control

export var maxSize = 1.0
export var targetT = 0.0

func _process(delta):
	self.rect_position.x = maxSize * targetT
