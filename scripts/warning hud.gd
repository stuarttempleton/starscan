extends CanvasLayer


func _ready():
	TurnOffICM()
	# warning-ignore:return_value_discarded
	$"../ShipAvatarView/IntraClusterMediumTracker".connect("enter_medium", self, "TurnOnICM")
	# warning-ignore:return_value_discarded
	$"../ShipAvatarView/IntraClusterMediumTracker".connect("exit_medium", self, "TurnOffICM")
	# warning-ignore:return_value_discarded
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
