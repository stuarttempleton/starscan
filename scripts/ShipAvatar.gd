extends KinematicBody2D

var target = Vector2()
var velocity = Vector2()
var MapScale = StarMapData.MapScale
var MinCameraZoom = 0.5
var MaxCameraZoom = 3

func _ready():
	self.position = Vector2(ShipData.Ship().X * MapScale, ShipData.Ship().Y * MapScale)
	target = self.position
	GameController.EnableDisableMovement(true)
	
func _input(event):
	if !GameController.is_paused && GameController.is_movement_enabled:
		if event.is_action_pressed('starmap_click'):
			#if position.distance_to(get_global_mouse_position()) <= Ship.Efficiency * MapScale :
			target = get_global_mouse_position()
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
				Zoom(0.25)
			if event.button_index == BUTTON_WHEEL_UP and event.pressed:
				Zoom(-0.25)

func Zoom(amount) :
	$Camera2D.zoom = Vector2(clamp($Camera2D.zoom.x + amount, MinCameraZoom, MaxCameraZoom), clamp($Camera2D.zoom.y + amount, MinCameraZoom, MaxCameraZoom) )
	
func HandleBoundary() :
	if target.x > MapScale :
		target.x = MapScale
	if target.y > MapScale :
		target.y = MapScale
	if target.x < 0 :
		target.x = 0
	if target.y < 0 :
		target.y = 0
		
func _physics_process(_delta):
	if GameController.is_paused: return
	
	HandleBoundary()
	
	var ship = ShipData.Ship()
	
	if position.distance_to(target) > 5:
		
		var distanceToTravel = ship.TravelSpeed * _delta
		var fuelRequired = distanceToTravel * ship.FuelPerUnitDistance
		
		if ship.Fuel >= fuelRequired:
			
			look_at(target)
			velocity = position.direction_to(target) * ship.TravelSpeed
			velocity = move_and_slide(velocity)
			ship.Fuel -= fuelRequired
			
		elif ship.Fuel > 0.001:
			
			look_at(target)
			var availableFuelFraction = ship.Fuel / ship.FuelPerUnitDistance
			velocity = position.direction_to(target) * ship.TravelSpeed * availableFuelFraction
			velocity = move_and_slide(velocity)
			ship.Fuel = 0.0
			
		else:
			
			ship.Fuel = 0.0
			#TODO: trigger fadeout and respawn at nearest outpost
	
	ship.X = position.x / MapScale
	ship.Y = position.y / MapScale
