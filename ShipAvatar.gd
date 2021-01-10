extends KinematicBody2D


export (int) var speed = 200

var target = Vector2()
var velocity = Vector2()
var Ship
var MapScale = StarMapData.MapScale

func _ready():
	Ship = ShipData.Ship()
	self.position = Vector2(Ship.X * MapScale, Ship.Y * MapScale)
	target = self.position
	
func _input(event):
	if event.is_action_pressed('starmap_click'):
		target = get_global_mouse_position()
		Ship.X = target.x / MapScale
		Ship.Y = target.y / MapScale

func HandleBoundary() :
	if target.x > MapScale :
		target.x = MapScale
	if target.y > MapScale :
		target.y = MapScale
	if target.x < 0 :
		target.x = 0
	if target.y < 0 :
		target.y = 0
		
func _physics_process(delta):
	velocity = position.direction_to(target) * speed
	look_at(target)
	HandleBoundary()
	
	if position.distance_to(target) > 5:
		velocity = move_and_slide(velocity)
