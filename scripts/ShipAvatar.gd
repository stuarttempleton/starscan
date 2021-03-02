extends KinematicBody2D

export (NodePath) var TargetDebug

var target = Vector2()
var velocity = Vector2()
var CurrentSpeed = 0
var MapScale = StarMapData.MapScale
var MinCameraZoom = 0.5
var MaxCameraZoom = 2
var mouseIsPressed = false
var ShipIsTowing = false
signal TowingAlert(bool_is_towing)

func _ready():
	self.position = Vector2(ShipData.Ship().X * MapScale, ShipData.Ship().Y * MapScale)
	target = self.position
	GameController.EnableMovement(true)
	TargetDebug = get_node(TargetDebug)
	ShipData.connect("FuelTanksEmpty", self, "_on_FuelTanksEmpty")
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

func HandleShipTowing():
	if ShipIsTowing:
		$LSS_Transporter.show()
	else:
		$LSS_Transporter.hide()


func HandleThrusters():
	if CurrentSpeed < 0.01 or ShipIsTowing:
		$Thruster1.emitting = false
		$Thruster1/Thruster2.emitting = false
		$Thruster2.emitting = false
		$Thruster2/Thruster2.emitting = false
	elif CurrentSpeed < ShipData.Ship().TravelSpeed / 2:
		$Thruster1.emitting = true
		$Thruster1/Thruster2.emitting = true
		$Thruster2.emitting = false
		$Thruster2/Thruster2.emitting = false
	elif CurrentSpeed < ShipData.Ship().TravelSpeed:
		$Thruster1.emitting = true
		$Thruster1/Thruster2.emitting = true
		$Thruster2.emitting = true
		$Thruster2/Thruster2.emitting = true
	pass


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
	var ship = ShipData.Ship()
	
	if mouseIsPressed and !ShipIsTowing:
		target = get_global_mouse_position()
		#CurrentSpeed = min(CurrentSpeed + _delta * ship.AccelerationRate, ship.TravelSpeed)
	
	HandleBoundary()
	HandleThrusters()
	HandleShipTowing()
	
	var distanceToTarget = position.distance_to(target)
	
	if distanceToTarget > 0.001:
		CurrentSpeed = min(CurrentSpeed + _delta * ship.AccelerationRate, ship.TravelSpeed)
	
	var distanceToTravel = min(CurrentSpeed * _delta, distanceToTarget)
	var approachSpeed = ship.TravelSpeed * 0.3
	var decelerate = (distanceToTarget - distanceToTravel < approachSpeed) and (CurrentSpeed > approachSpeed)
	
	if distanceToTravel > 0.001 && ((ship.Fuel > 0.001) or ShipIsTowing):
		if decelerate:
			CurrentSpeed = max(CurrentSpeed - _delta * ship.AccelerationRate * distanceToTravel, approachSpeed)
			
		var fuelRequired = min(distanceToTravel * ship.FuelPerUnitDistance, ship.Fuel)
		var availableFuelFraction = min(1.0, ship.Fuel / ship.FuelPerUnitDistance)
		if ShipIsTowing:
			availableFuelFraction = 1
		var speedToHitTargetThisFrame = availableFuelFraction * distanceToTravel / _delta
		
		look_at(target)
		velocity = position.direction_to(target) * speedToHitTargetThisFrame
		velocity = move_and_slide(velocity)
		if !ShipIsTowing:
			ShipData.ConsumeFuel(fuelRequired)
			
	else:
		
		target = position
		CurrentSpeed = 0
		if ShipIsTowing:
			TurnOffTow()
	
	TargetDebug.position = target
	_setMapPosition(position)

func TurnOffTow():
	ShipIsTowing = false
	print("Tow complete.")
	#$LSS_Transporter.hide()
	emit_signal("TowingAlert", ShipIsTowing)


func TowShipTo(_outpost_position):
	print("Towing ship to... " + str(_outpost_position))
	ShipIsTowing = true
	target = _outpost_position
	#$LSS_Transporter.show()
	emit_signal("TowingAlert", ShipIsTowing)


func _setMapPosition(newPosition):
	position = newPosition
	ShipData.Ship().X = position.x / MapScale
	ShipData.Ship().Y = position.y / MapScale

func JumpToMapPosition(newPosition):
	_setMapPosition(newPosition)
	target = newPosition
	mouseIsPressed = false

func _on_FuelTanksEmpty():
	if !ShipIsTowing:
		var shipPos = Vector2(ShipData.Ship().X,ShipData.Ship().Y)
		var nearestOutpostSystem = StarMapData.GetNearestOutpostSystem(shipPos)
	
		GameNarrativeDisplay.connect("ChoiceSelected", self, "DialogChoice")
		GameNarrativeDisplay.DisplayText(StoryGenerator.LowFuel(nearestOutpostSystem),["OK"])


func DialogChoice(choice):
	GameNarrativeDisplay.disconnect("ChoiceSelected",self,"DialogChoice")
	
	var shipPos = Vector2(ShipData.Ship().X,ShipData.Ship().Y)
	var nearestOutpostSystem = StarMapData.GetNearestOutpostSystem(shipPos)
	var outpostSystemPos = Vector2(nearestOutpostSystem.X, nearestOutpostSystem.Y) * StarMapData.MapScale

	TowShipTo(outpostSystemPos)
