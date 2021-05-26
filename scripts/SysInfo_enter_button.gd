extends Button

export(String) var SystemViewport_scene
var hoverflag = false

func _ready():
	connect("mouse_entered",self,"mouse_enter")
	connect("mouse_exited",self,"mouse_exit")


func mouse_enter():
	hoverflag = true
	GameController.EnableMovement(false)


func mouse_exit():
	if hoverflag:
		GameController.EnableMovement(true)


func _on_button_down():
	AudioPlayer._play_UI_Button_Select()
	hoverflag = false
	SceneChanger.LoadScene(SystemViewport_scene)
