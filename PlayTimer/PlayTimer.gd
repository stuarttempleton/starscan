extends Node


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var TimerActiveStack = 0
var TimerStarted = false
var MaxTimerSizeInSeconds = 60 * 60 * 24

# Called when the node enters the scene tree for the first time.
func _ready():
	# warning-ignore:return_value_discarded
	GameController.connect("gameloop_state",Callable(self,"GameLoopState"))
	# warning-ignore:return_value_discarded
	GameController.connect("pause_state",Callable(self,"PauseTimer"))
#	testPrint(2,3,4)
#	testPrint(0,3,4)
#	testPrint(0,0,4)
#	testPrint(0,3,0)
#	testPrint(2,0,0)
#	testPrint(2,3,0)
#
#func testPrint(hours, minutes, seconds):
#	print("Your journey ended in%s%s%s." % [" %dhrs" %[hours] if hours > 1 else "", " %dmin" %[minutes] if minutes > 1 else ""," %dsec" %[seconds] if seconds > 1 else ""])

func GameLoopState(started):
	TimerStarted = started
	
func PauseTimer(paused):
	TimerActiveStack += 1 if paused else -1 #push/pop to stack
	if TimerActiveStack < 0: TimerActiveStack = 0
	
func ResetTimer():
	TimerActiveStack = 0
	TimerStarted = false

func _process(delta):
	if TimerActiveStack < 1 and TimerStarted:
		ShipData.UpdatePlayStat("PlayDuration",delta)
