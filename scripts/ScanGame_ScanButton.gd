extends Button

func _mouse_entered():
	GameController.EnableDisableMovement(false)

func _mouse_exited():
	GameController.EnableDisableMovement(true)
