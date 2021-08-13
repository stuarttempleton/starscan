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
	var Nearby = StarMapData.GetNearestBody()
	if Nearby.has("Destination"):
		var Destination = StarMapData.GetBodyByName(Nearby.Destination, "Nebulae")
		var Wormhole = get_tree().get_root().find_node("WormholeAction", true, false)
		Wormhole.EnterWormholeTo(StarMapData.SystemPosition(Destination, true))
	else:
		hoverflag = false
		SceneChanger.LoadScene(SystemViewport_scene)
