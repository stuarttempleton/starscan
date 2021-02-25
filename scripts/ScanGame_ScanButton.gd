extends Button

func _mouse_entered():
	GameController.EnableMovement(false)

func _mouse_exited():
	GameController.EnableMovement(true)
