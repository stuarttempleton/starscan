extends TextureRect


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var MapScale = StarMapData.MapScale

# Called when the node enters the scene tree for the first time.
func _ready():
	position = Vector2( 0, 0 )
	size = Vector2(  MapScale,  MapScale )
	pass # Replace with function body.


