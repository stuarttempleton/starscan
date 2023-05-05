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
		if $GPUParticles2D.modulate.a <= max_alpha:
			$GPUParticles2D.modulate.a = clamp($GPUParticles2D.modulate.a + delta * fade_rate, min_alpha, max_alpha)
	else:
		if $GPUParticles2D.modulate.a >= min_alpha:
			$GPUParticles2D.modulate.a = clamp($GPUParticles2D.modulate.a - delta * fade_rate, min_alpha, max_alpha)

func Appear():
	reveal = true
	$GPUParticles2D.emitting = true

func Disappear():
	reveal = false
	$GPUParticles2D.emitting = false
