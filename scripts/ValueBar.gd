extends Control

@export var ship_value_key: String
@export var ship_capacity_key: String
@export var warn_fraction: float
@export var normal_color: Color
@export var warn_color: Color
@export var Lerp_Rate: float

@export var bg_animator_path: NodePath
@export var scale_bar_path: NodePath
@export var bar_particles_path: NodePath
@export var fill_colorrect_path: NodePath

@onready var bg_animator = get_node(bg_animator_path)
@onready var scale_bar = get_node(scale_bar_path)
@onready var bar_particles = get_node(bar_particles_path)
@onready var fill_colorrect = get_node(fill_colorrect_path)

var targetScaleX
var currentState = State.Normal

func _ready():
	var startFraction = GetModelFraction()
	SetPercent(startFraction)
	DisplayFraction(startFraction)
	HandleState()

func _process(_delta):
	Refresh()

func Refresh():
	SetPercent(GetModelFraction())
	EaseToTarget()
	HandleState()
		
func EaseToTarget():
	var fractionDiff = scale_bar.scale.x - targetScaleX
	bar_particles.set_emitting(fractionDiff > 0.001)
	if (abs(fractionDiff) > 0.001) :
		var fractionDelta = fractionDiff * Lerp_Rate
		var newFraction = scale_bar.scale.x - fractionDelta
		DisplayFraction(newFraction)
		
func GetModelFraction() -> float:
	var value = ShipData.StarShip[ship_value_key]
	var capacity = ShipData.StarShip[ship_capacity_key]
	return value / capacity
	
func DisplayFraction(newFraction):
	scale_bar.scale = Vector2(newFraction, 1)
	
func SetPercent(fraction) :
	if (fraction > 1.0):
		fraction = 1.0
	targetScaleX = fraction

func HandleState():
	for stateName in State:
		var targetState = State[stateName]
		if (currentState != targetState && CheckStateCondition(targetState)):
			ChangeState(targetState)
			break
		
func CheckStateCondition(targetState) -> bool:
	match targetState:
		State.MegaWarn:
			return targetScaleX <= 0.001
		State.Warn:
			return currentState != State.MegaWarn && targetScaleX <= warn_fraction
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
		State.MegaWarn:
			bg_animator.stop()
		State.Warn:
			bg_animator.stop()
		State.Normal:
			pass
		_:
			print("State has no exit work: %s" % oldState)
			
func DoStateEnterWork(newState):
	match newState:
		State.MegaWarn:
			fill_colorrect.color = warn_color
			bg_animator.play("WarnFlash", -1, 2.0)
		State.Warn:
			fill_colorrect.color = warn_color
			bg_animator.play("WarnFlash")
		State.Normal:
			fill_colorrect.color = normal_color
		_:
			print("State has no enter work: %s" % newState)

enum State {
	Normal,
	MegaWarn,
	Warn
}
