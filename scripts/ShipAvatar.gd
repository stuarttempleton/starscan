extends KinematicBody2D

var target = Vector2()
var velocity = Vector2()
var CurrentSpeed = 0
var MapScale = StarMapData.MapScale
var MinCameraZoom = 1
var MaxCameraZoom = 4
var MapCameraZoom = 14
var MapSavedZoom
var mouseIsPressed = false
var ShipIsTowing = false
var UsingMap = false
var look_enabled = true

signal TowingAlert(bool_is_towing)
var playedWarpOnce = false

func _ready():
	self.position = Vector2(ShipData.Ship().X * MapScale, ShipData.Ship().Y * MapScale)
	target = self.position
	GameController.ResetMoveBlock()
	# warning-ignore:return_value_discarded
	ShipData.connect("FuelTanksEmpty", self, "_on_FuelTanksEmpty")
	# warning-ignore:return_value_discarded
	GameController.connect("map_state", self, "MapToggle")

func _input(event):
	if GameController.is_movement_enabled():
		if event is InputEventMouseButton and !UsingMap:
			if event.button_index == BUTTON_LEFT:
				mouseIsPressed = event.pressed
			elif event.button_index == BUTTON_WHEEL_DOWN and event.pressed:
				Zoom(0.25)
			elif event.button_index == BUTTON_WHEEL_UP and event.pressed:
				Zoom(-0.25)


func MapToggle(_useMap):
	if !_useMap:
		$Camera2D.zoom = MapSavedZoom
		$StarField.show()
		$FuelRange.hide()
	else:
		MapSavedZoom = $Camera2D.zoom
		$Camera2D.zoom = Vector2(MapCameraZoom, MapCameraZoom)
		$StarField.hide()
		$FuelRange.show()
	
	UsingMap = _useMap

func Zoom(amount) :
	$Camera2D.zoom = Vector2(clamp($Camera2D.zoom.x + amount, MinCameraZoom, MaxCameraZoom), clamp($Camera2D.zoom.y + amount, MinCameraZoom, MaxCameraZoom) )
	
	
func HandleShipTowing():
	if ShipIsTowing:
		$LSS_Transporter.show()
		if !$LSS_Transporter/Audio.playing:
			$LSS_Transporter/Audio.play()
	else:
		$LSS_Transporter.hide()
		if $LSS_Transporter/Audio.playing:
			$LSS_Transporter/Audio.stop()


func HandleThrusters():
	if CurrentSpeed < 0.01 or ShipIsTowing:
		$Thruster.emitting = false
		$Thruster/Thruster2.emitting = false
		$Warpdrive.emitting = false
		$Warpdrive/Thruster2.emitting = false
		$Thruster/Audio.stop()
		$Warpdrive/Audio.stop()
	elif CurrentSpeed < ShipData.Ship().TravelSpeed / 2:
		playedWarpOnce = false #since dropping speed, we have not played it.
		$Thruster.emitting = true
		$Thruster/Thruster2.emitting = true
		$Warpdrive.emitting = false
		$Warpdrive/Thruster2.emitting = false
		if !$Thruster/Audio.playing:
			$Thruster/Audio.play()
		if $Warpdrive/Audio.playing:
			$Warpdrive/Audio.stop()
	elif CurrentSpeed < ShipData.Ship().TravelSpeed:
		$Thruster.emitting = true
		$Thruster/Thruster2.emitting = true
		$Warpdrive.emitting = true
		$Warpdrive/Thruster2.emitting = true
#		if $Thruster/Audio.playing:
#			$Thruster/Audio.stop()
		if !$Warpdrive/Audio.playing:
			$Warpdrive/Audio.play()
		if !$Warpdrive/SpeedShift.playing and !playedWarpOnce:
			$Warpdrive/SpeedShift.play()
		playedWarpOnce = true #you played it if it wasn't playing. move on.
			
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
		if MovementEvent.is_valid(get_viewport().get_mouse_position()):
			target = get_global_mouse_position()
	
	if !ship.WarpDrive: #TODO: UPGRADE INVENTORY
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
		var availableFuelFraction = min(1.0, ship.Fuel / ship.FuelPerUnitDistance )
		if ShipIsTowing:
			availableFuelFraction = 1
		var speedToHitTargetThisFrame = availableFuelFraction * distanceToTravel / _delta
		
		if look_enabled:
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
	_setMapPosition(position)

func TurnOffTow():
	ShipIsTowing = false
	emit_signal("TowingAlert", ShipIsTowing)


func TowShipTo(_outpost_position):
	ShipIsTowing = true
	target = _outpost_position
	emit_signal("TowingAlert", ShipIsTowing)


func _setMapPosition(newPosition):
	position = newPosition
	ShipData.Ship().X = position.x / MapScale
	ShipData.Ship().Y = position.y / MapScale

func JumpToMapPosition(newPosition):
	_setMapPosition(newPosition)
	target = newPosition
	mouseIsPressed = false

var TowEncounter = {"Friendly":true, "Artifacts":0, "Crew":0, "nearestOutpostSystem":0}

func _on_FuelTanksEmpty():
	if !ShipIsTowing && !ShipData.Ship().FirstRun:
		var shipPos = Vector2(ShipData.Ship().X,ShipData.Ship().Y)
		var outpost = StarMapData.GetNearestOutpostSystem(shipPos)
		var distanceToOutpost = StarMapData.GetDistanceToSystem(shipPos, outpost)
		var chanceOfHostile = distanceToOutpost * 10 
		if chanceOfHostile > 0.5:
			chanceOfHostile += 0.2
		elif chanceOfHostile < 0.2:
			chanceOfHostile -= 0.2
		TowEncounter = {"Friendly":true if randf() > chanceOfHostile else false, 
						"Artifacts": randi() % int(ShipData.GetInventoryQTYFor("Artifacts") + 1),
						"Crew": 1 + randi() % 1, #int(ShipData.StarShip.CrewCapacity / 2 - 1),
						"nearestOutpostSystem": outpost}
		var opts = ["OK"]
		if !TowEncounter.Friendly:
			opts = ["%s CREW" % [TowEncounter.Crew]]
			if TowEncounter.Artifacts > 0:
				opts.append("%s ARTIFACT%s" % [TowEncounter.Artifacts, "S" if TowEncounter.Artifacts > 1 else ""])
		AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.DIALOG_HAIL_FRIENDLY if TowEncounter.Friendly else AudioPlayer.AUDIO_KEY.DIALOG_HAIL_HOSTILE)
		# warning-ignore:return_value_discarded
		GameNarrativeDisplay.connect("ChoiceSelected", self, "DialogChoice")
		GameNarrativeDisplay.DisplayText(StoryGenerator.LowFuel(TowEncounter),opts)


func DialogChoice(choice):
	GameNarrativeDisplay.disconnect("ChoiceSelected",self,"DialogChoice")
	if choice == 0:
		if !TowEncounter.Friendly:
			ShipData.UpdatePlayStat("Conscripts",ShipData.DeductCrew(TowEncounter.Crew))
		pass
	if choice == 1:
		if !TowEncounter.Friendly:
			ShipData.UpdatePlayStat("Bribes",ShipData.DeductArtifact(TowEncounter.Artifacts))
		pass
	var outpostSystemPos = Vector2(TowEncounter.nearestOutpostSystem.X, TowEncounter.nearestOutpostSystem.Y) * StarMapData.MapScale
	if ShipData.Ship().Crew > 0:
		ShipData.UpdatePlayStat("Tows",1)
		TowShipTo(outpostSystemPos)
