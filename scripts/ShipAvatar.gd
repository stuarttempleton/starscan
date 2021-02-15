extends KinematicBody2D

export (NodePath) var TargetDebug

var target = Vector2()
var velocity = Vector2()
var MapScale = StarMapData.MapScale
var MinCameraZoom = 0.5
var MaxCameraZoom = 2
var mouseIsPressed = false

func _ready():
	self.position = Vector2(ShipData.Ship().X * MapScale, ShipData.Ship().Y * MapScale)
	target = self.position
	GameController.EnableDisableMovement(true)
	TargetDebug = get_node(TargetDebug)
	if not OS.is_debug_build():
		TargetDebug.queue_free()
	
func _input(event):
	if GameController.is_movement_enabled:
		if event is InputEventMouseButton:
			if event.button_index == BUTTON_LEFT:
				mouseIsPressed = event.pressed
			elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
				Zoom(0.25)
			elif event.button_index == BUTTON_WHEEL_UP and event.pressed:
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
	
	if mouseIsPressed:
		target = get_global_mouse_position()
	
	HandleBoundary()
	
	var ship = ShipData.Ship()
	var distanceToTravel = min(ship.TravelSpeed * _delta, position.distance_to(target))
	
	if distanceToTravel > 0.001 && ship.Fuel > 0.001:
		
		var fuelRequired = min(distanceToTravel * ship.FuelPerUnitDistance, ship.Fuel)
		var availableFuelFraction = min(1.0, ship.Fuel / ship.FuelPerUnitDistance)
		var speedToHitTargetThisFrame = availableFuelFraction * distanceToTravel / _delta
		
		look_at(target)
		velocity = position.direction_to(target) * speedToHitTargetThisFrame
		velocity = move_and_slide(velocity)
		ShipData.ConsumeFuel(fuelRequired)
			
	else:
		
		target = position
	
	TargetDebug.position = target
	_setMapPosition(position)

func _setMapPosition(newPosition):
	position = newPosition
	ShipData.Ship().X = position.x / MapScale
	ShipData.Ship().Y = position.y / MapScale

func JumpToMapPosition(newPosition):
	_setMapPosition(newPosition)
	target = newPosition
	mouseIsPressed = false
