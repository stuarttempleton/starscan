extends Node

export(NodePath) var oscillator_path
onready var oscillator = get_node(oscillator_path)

export(NodePath) var bg_path
onready var bg = get_node(bg_path)

export(NodePath) var sweetSpot_path
onready var sweetSpot = get_node(sweetSpot_path)

signal success
signal fail
signal complete

export(Curve) var success_curve
export(Curve) var speed_curve
export var speed = 0.5
export var greenMin = 0.4
export var greenMax = 0.6
const amplitude = 2.0
var x = amplitude #starting at maxX ensures the bar always starts at the left end

var scanButtonPressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.PlayBG(AudioPlayer.AUDIO_KEY.SCAN_OSCILLATOR)
	GameController.EnableMovement(false)
	if (StarMapData.NearestSystem == null):
		StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
	$Title.text = $Title.text % [StarMapData.NearestSystem.Name]
	
	#Fit oscillator within bg assuming bg offset left of origin is margin
	var bgMargin = -bg.rect_position.x
	oscillator.maxSize = bg.rect_size.x - bgMargin * 2
	
	SetupSweetSpot()
	
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
	var score = success_curve.interpolate(abs(x - 1.0))
	var success = (score >= greenMin and score <= greenMax)
	print("Scanned! x=" + str(x) + ", max=" + str(amplitude) + ", scored " + str(score) + ", goal range=" + str(greenMin) + "..." + str(greenMax) + ". Result: " + ("Success." if success else "Fail."))
	handleScanResult(success, score)

func reset():
	scanButtonPressed = false
	$ScanButton.disabled = false

func SetupSweetSpot():
	assert(success_curve.get_point_count() == 4, "Scanner minigame success curve must have exactly 4 points")
	var leftMin = success_curve.get_point_position(0)
	var leftMax = success_curve.get_point_position(1)
	var rightMax = success_curve.get_point_position(2)
	var rightMin = success_curve.get_point_position(3)
	
	var gradient = sweetSpot.texture.gradient
	assert(gradient.get_point_count() == 4, "Scanner minigame sweet spot gradient must have exactly 4 points")
	gradient.set_offset(0, leftMin.x)
	gradient.set_offset(1, leftMax.x)
	gradient.set_offset(2, rightMax.x)
	gradient.set_offset(3, rightMin.x)
	
	#Place target zone as a fraction of max oscillator size
	sweetSpot.rect_position.x = oscillator.maxSize * leftMin.x
	sweetSpot.rect_size.x = oscillator.maxSize * (rightMin.x - leftMin.x)

func updateText(percent, confidence):
	$Description.text = "Scan complete: %s\r\nConfidence: %s" % [percent, confidence]
	pass
	
func scanFailed():
	AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.SCAN_LOSE)
	var scanAccuracy = 0.5
	$ResultTextHandle/ResultText.text = str(int(scanAccuracy * 10) * 10) + "%"
	updateText(str(int(scanAccuracy * 10) * 10), "LOW")
	$ResultTextHandle/ResultTextAnimator.play("WinAnim")
	StarMapData.ScanNearestSystem(scanAccuracy)
	emit_signal("fail")
	
func scanSucceeded():
	AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.SCAN_WIN)
	var scanAccuracy = 1.0
	$ResultTextHandle/ResultText.text = str(int(scanAccuracy * 10) * 10) + "%"
	updateText(str(int(scanAccuracy * 10) * 10), "HIGH")
	$ResultTextHandle/ResultTextAnimator.play("WinAnim")
	if StarMapData.ScanNearestSystem(scanAccuracy):
		print("adding scan data to inventory")
		ShipData.GainInventoryItem("Scan Data", 1)
	emit_signal("success")

func handleScanResult(isSuccess, accuracy):
	AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.SCAN_WIN if isSuccess else AudioPlayer.AUDIO_KEY.SCAN_LOSE)
	$ResultTextHandle/ResultText.text = str(int(accuracy * 10) * 10) + "%"
	updateText(str(int(accuracy * 10) * 10), "HIGH" if accuracy > 0.5 else "LOW")
	$ResultTextHandle/ResultTextAnimator.play("WinAnim")
	if StarMapData.ScanNearestSystem(accuracy) && isSuccess:
		print("adding scan data to inventory")
		ShipData.GainInventoryItem("Scan Data", 1)
	emit_signal("success" if isSuccess else "fail")

func _on_endAnimComplete():
	emit_signal("complete")
	GameController.EnableMovement(true)
	get_parent().get_parent().get_parent().queue_free()
