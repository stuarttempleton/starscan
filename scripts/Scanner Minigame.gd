extends Node

export(NodePath) var oscillator_path
var oscillator

export(NodePath) var bg_path
var bg

export(NodePath) var targetZone_path
var targetZone

signal success
signal fail
signal complete

export var speed = 0.5
export var greenMin = 0.4
export var greenMax = 0.6
const amplitude = 2.0
var x = amplitude #starting at maxX ensures the bar always starts at the left end

var scanButtonPressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	GameController.EnableMovement(false)
	if (StarMapData.NearestSystem == null):
		StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
	$Title.text = $Title.text % [StarMapData.NearestSystem.Name]
	oscillator = $Oscillator
	bg = $BG
	targetZone = $TargetZone
	
	#Fit oscillator within bg assuming bg offset left of origin is margin
	var bgMargin = -bg.rect_position.x
	oscillator.maxSize = bg.rect_size.x - bgMargin * 2
	
	#Place target zone as a fraction of max oscillator size
	targetZone.rect_position.x = oscillator.maxSize * greenMin
	targetZone.rect_size.x = oscillator.maxSize * (greenMax - greenMin)
	
	#These lines only exist for diagnostic purposes, remove them
	#self.connect("success", self, "_reset")
	#self.connect("fail", self, "_reset")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not scanButtonPressed:
		x = fmod(x + delta * speed, amplitude)
		oscillator.targetT = abs(x - 1.0)

func _on_Button_pressed():
	scanButtonPressed = true
	$ScanButton.disabled = true
	var score = abs(x - 1.0)
	var success = (score >= greenMin and score <= greenMax)
	print("Scanned! x=" + str(x) + ", max=" + str(amplitude) + ", scored " + str(score) + ", goal range=" + str(greenMin) + "..." + str(greenMax) + ". Result: " + ("Success." if success else "Fail."))
	if success:
		scanSucceeded()
	else:
		scanFailed()
	#emit_signal("success" if success else "fail")

func reset():
	scanButtonPressed = false
	$ScanButton.disabled = false

func updateText(percent, confidence):
	$Description.text = "Scan complete: %s\r\nConfidence: %s" % [percent, confidence]
	pass
	
func scanFailed():
	var scanAccuracy = 0.5
	$ResultTextHandle/ResultText.text = str(int(scanAccuracy * 10) * 10) + "%"
	updateText(str(int(scanAccuracy * 10) * 10), "LOW")
	$ResultTextHandle/ResultTextAnimator.play("WinAnim")
	StarMapData.ScanNearestSystem(scanAccuracy)
	emit_signal("fail")
	
func scanSucceeded():
	var scanAccuracy = 1.0
	$ResultTextHandle/ResultText.text = str(int(scanAccuracy * 10) * 10) + "%"
	updateText(str(int(scanAccuracy * 10) * 10), "HIGH")
	$ResultTextHandle/ResultTextAnimator.play("WinAnim")
	StarMapData.ScanNearestSystem(scanAccuracy)
	emit_signal("success")

func _on_endAnimComplete():
	emit_signal("complete")
	GameController.EnableMovement(true)
	get_parent().get_parent().get_parent().queue_free()
