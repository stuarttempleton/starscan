extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var _showRange = false
var ship = ShipData.Ship()
var fuel_range = 0
var target = Vector2(0,0)
# Called when the node enters the scene tree for the first time.
func _ready():
	target = Vector2(get_parent().global_position.x, get_parent().global_position.y)
	pass # Replace with function body.

func _draw():
	#draw_circle(to_local(target), fuel_range ,Color(1, 1, 1))
	draw_circle_arc(to_local(target), fuel_range, 0, 360, Color(0, 0.20813, 0.429688))
	draw_circle_arc(to_local(target), fuel_range * 0.66, 0, 360, Color(0, 0.327331, 0.675781))
	draw_circle_arc(to_local(target), fuel_range * 0.33, 0, 360, Color(0.198944, 0.568035, 0.960938))


func _process(delta):
	target = Vector2(get_parent().global_position.x, get_parent().global_position.y)
	fuel_range = ship.Fuel / ship.FuelPerUnitDistance
	update()
	#$star_100px.scale = Vector2(fuel_range / 100, fuel_range / 100)

func draw_circle_arc(center, radius, angle_from, angle_to, color):
	var nb_points = 64
	var points_arc = PoolVector2Array()

	for i in range(nb_points + 1):
		var angle_point = deg2rad(angle_from + i * (angle_to-angle_from) / nb_points - 90)
		points_arc.push_back(center + Vector2(cos(angle_point), sin(angle_point)) * radius)

	for index_point in range(nb_points):
		draw_line(points_arc[index_point], points_arc[index_point + 1], color)
