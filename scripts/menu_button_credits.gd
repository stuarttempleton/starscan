extends Button

export var scene_to_load = ""


func _ready():
	pass # Replace with function body.


func handleSelect():
	if (scene_to_load != "") :
		AudioPlayer._play_UI_Button_Select()
		#AudioPlayer.FadeOutMusic(2)
		SceneChanger.LoadScene(scene_to_load,0.5)
	else :
		print("THIS MENU BUTTON HAS NO SCENE TO LOAD")



func _on_Credits_button_down():
	handleSelect()
