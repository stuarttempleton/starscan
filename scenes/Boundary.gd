extends TextureRect


var MapScale = StarMapData.MapScale
#like a clock: 0, 1, 2, 3

export var Side = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	match Side:
		0: top()
		1: right()
		2: bottom()
		3: left()
	pass # Replace with function body.

func top():
	set_rotation_degrees(0)
	rect_position = Vector2( 0, 0 - get_size().y )
	rect_size = Vector2(  MapScale,  get_size().y )
	pass
	
func bottom():
	set_rotation_degrees(0)
	rect_position = Vector2( 0, MapScale )
	rect_size = Vector2(  MapScale,  get_size().y )
	pass
	
func right():
	set_rotation_degrees(90)
	rect_position = Vector2( MapScale + get_size().y, 0 )
	rect_size = Vector2(  MapScale,  get_size().y )
	pass
	
func left():
	set_rotation_degrees(-90)
	rect_position = Vector2( -get_size().y, MapScale )
	rect_size = Vector2(  MapScale,  get_size().y )
	pass
