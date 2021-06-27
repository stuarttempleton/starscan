extends Node

export(NodePath) var oscillator_path
onready var oscillator = get_node(oscillator_path)

export(NodePath) var bg_path
onready var bg = get_node(bg_path)

export(NodePath) var sweetSpot_path
onready var sweetSpot = get_node(sweetSpot_path)

export(NodePath) var resultTextLabel_path
onready var resultTextLabel = get_node(resultTextLabel_path)

export(NodePath) var resultTextAnimator_path
onready var resultTextAnimator = get_node(resultTextAnimator_path)

export(NodePath) var minigameRoot_path
onready var minigameRoot = get_node(minigameRoot_path)

signal success
signal fail
signal complete

export(Curve) var success_curve
export(Curve) var speed_curve
export var speed = 0.5
export var greenMin = 0.4
export var greenMax = 0.6

const amplitude = 2.0
var x = amplitude / 2 #this initial value starts the oscillator on the left end
var oscillatorRange

var scanButtonPressed = false

# Called when the node enters the scene tree for the first time.
func _ready():
	AudioPlayer.PlayBG(AudioPlayer.AUDIO_KEY.SCAN_OSCILLATOR)
	GameController.EnableMovement(false)
	if (StarMapData.NearestSystem == null):
		StarMapData.FindNearestSystem(Vector2(ShipData.Ship().X,ShipData.Ship().Y))
	$Title.text = $Title.text % [StarMapData.NearestSystem.Name]
	
	#Fit oscillator within bg assuming sbg offset left of origin is margin
	var bgMargin = -bg.rect_position.x
	oscillatorRange = bg.rect_size.x - bgMargin * 2
	
	SetupSweetSpot()

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if not scanButtonPressed:
		x = fmod(x + delta * speed, amplitude)
		oscillator.rect_position.x = oscillatorRange * abs(x - 1.0)

func _on_Button_pressed():
	scanButtonPressed = true
	$ScanButton.disabled = true
	var score = success_curve.interpolate(abs(x - 1.0))
	var success = score > 0.5
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
	sweetSpot.rect_position.x = oscillatorRange * leftMin.x
	sweetSpot.rect_size.x = oscillatorRange * (rightMin.x - leftMin.x)

func updateText(percent, confidence):
	$Description.text = "Scan complete: %s%%\r\nConfidence: %s" % [percent, confidence]
	pass

func handleScanResult(isSuccess, accuracy):
	AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.SCAN_WIN if isSuccess else AudioPlayer.AUDIO_KEY.SCAN_LOSE)
	resultTextLabel.text = str(int(accuracy * 100)) + "%"
	updateText(str(int(accuracy * 100)), "HIGH" if isSuccess else "LOW")
	resultTextAnimator.play("WinAnim")
	if StarMapData.ScanNearestSystem(accuracy) && isSuccess:
		ShipData.GainInventoryItem("Scan Data", 1)
		ShipData.UpdatePlayStat("SystemsScanned",1)
	var resultSignal = "success" if isSuccess else "fail"
	emit_signal(resultSignal)

func _on_endAnimComplete():
	emit_signal("complete")
	GameController.EnableMovement(true)
	minigameRoot.queue_free()

