extends CanvasLayer


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

export var VersionNumber = "0.01a"
export var VersionClass = "Preview"
export var UseBuildOverlay = true

# Called when the node enters the scene tree for the first time.
func _ready():
	if UseBuildOverlay:
		$BuildNumber.text = $BuildNumber.text % [VersionClass, VersionNumber]
	else:
		queue_free()

