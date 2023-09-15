extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var VersionNumber = "0.01a"
export var VersionClass = "Preview"
export var UseBuildOverlay = true
export var UseFPSCounter = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if UseBuildOverlay:
		$BuildNumber.text = $BuildNumber.text % [VersionClass, VersionNumber]
	else:
		queue_free()

func _process(delta):
	if UseFPSCounter:
		$FPSCount.set_text( "FPS: %d" % Engine.get_frames_per_second())
