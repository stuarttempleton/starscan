extends ColorRect

export(String) var ship_value_key
export(String) var ship_capacity_key
export(float) var warn_fraction
export(Color) var normal_color
export(Color) var warn_color
export(float) var Lerp_Rate = 0.9

var targetScaleX = 1.0
var currentState = State.Normal

func _ready():
	print("%s %f, %s %f" % [ship_value_key, ShipData.StarShip[ship_value_key], ship_capacity_key, ShipData.StarShip[ship_capacity_key]])
	#Refresh()

func _process(_delta):
	Refresh()

func Refresh():
	var value = ShipData.StarShip[ship_value_key]
	var capacity = ShipData.StarShip[ship_capacity_key]
	SetPercent(value / capacity)
	LerpToTarget()
		
func LerpToTarget():
	var fractionDiff = rect_scale.x - targetScaleX
	if (abs(fractionDiff) > 0.001) :
		var fractionDelta = fractionDiff * Lerp_Rate
		var newX = rect_scale.x - fractionDelta
		rect_scale = Vector2(newX, 1)
	
func SetPercent(fraction) :
	if (fraction > 1.0):
		print("%s fraction %f is too high, clamping to 1.0" % [ship_value_key, fraction])
		fraction = 1.0
		
	if (fraction != targetScaleX):
		#TODO: value just changed, trigger attention-grabbing effects?
		pass
	targetScaleX = fraction
	
	HandleState()

func HandleState():
	for stateName in State:
		var targetState = State[stateName]
		if (currentState != targetState && CheckStateCondition(targetState)):
			ChangeState(targetState)
			break
		
func CheckStateCondition(targetState) -> bool:		
	match targetState:
		State.Warn:
			return targetScaleX <= warn_fraction
		State.Normal:
			return targetScaleX > warn_fraction
		_:
			print("State has no condition: %s" % targetState)
			return false

func ChangeState(newState):
	DoStateExitWork(currentState)
	currentState = newState
	DoStateEnterWork(newState)
	
func DoStateExitWork(oldState):
	match oldState:
		State.Warn:
			pass
		State.Normal:
			pass
		_:
			print("State has no exit work: %s" % oldState)
			
func DoStateEnterWork(newState):
	match newState:
		State.Warn:
			color = warn_color
			#TODO: play Warn fx
		State.Normal:
			color = normal_color
			#TODO: play Normal fx
		_:
			print("State has no enter work: %s" % newState)

enum State {
	Normal,
	Warn
}
