extends CanvasLayer


func _ready():
	TurnOffICM()
	$"../ShipAvatarView/IntraClusterMediumTracker".connect("enter_medium", self, "TurnOnICM")
	$"../ShipAvatarView/IntraClusterMediumTracker".connect("exit_medium", self, "TurnOffICM")
	$"../ShipAvatarView/IntraClusterMediumTracker".connect("inside_medium", self, "CheckICM")


func TurnOnICM():
	$IntraclusterMedium.show()
	$IntraclusterMedium/AnimationPlayer.play("WarningFade")


func TurnOffICM():
	$IntraclusterMedium.hide()
	$IntraclusterMedium/AnimationPlayer.stop(false)

func CheckICM():
	if !$IntraclusterMedium/AnimationPlayer.is_playing():
		TurnOnICM()
