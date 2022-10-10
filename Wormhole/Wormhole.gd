extends Node2D

var fade_rate = 3
var max_alpha = 0.9
var min_alpha = 0
var reveal = false

func _ready():
	reveal = true
	pass

func _process(delta):
	if position.distance_to(ShipData.GetPosition()) > 300 || StarMapData.GetNearestBody() == null:
		Disappear()
	elif StarMapData.GetNearestBody().Scan > 0:
		Appear()
		
	if reveal:
		if $Particles2D.modulate.a <= max_alpha:
			$Particles2D.modulate.a = clamp($Particles2D.modulate.a + delta * fade_rate, min_alpha, max_alpha)
	else:
		if $Particles2D.modulate.a >= min_alpha:
			$Particles2D.modulate.a = clamp($Particles2D.modulate.a - delta * fade_rate, min_alpha, max_alpha)

func Appear():
	reveal = true
	$Particles2D.emitting = true

func Disappear():
	reveal = false
	$Particles2D.emitting = false
