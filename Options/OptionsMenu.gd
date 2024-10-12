extends CanvasLayer

var is_dragging = false
var last_val = 1

var menu_items = []


func _ready():
	menu_items = [
		$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/FullscreenButton,
		$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/Scale/HSlider,
		$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/FPSButton,
		$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/MusicButton,
		$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/SFXButton,
		$OptionsMenu/ButtonsContainer/HBoxContainer/Done,
		$OptionsMenu/ButtonsContainer/HBoxContainer/Defaults
	]
	GameController.connect("options_state", self, "ShowOptionsMenu")
	ShowOptionsMenu(false)
	print("Done: %s" % [($OptionsMenu/ButtonsContainer/HBoxContainer/Done is HSlider)])
	print("Slider: %s" % [($OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/Scale/HSlider is HSlider)])


func ShowOptionsMenu(state:bool=true):
	if state:
		MovementEvent.add_deadzone(name, $OptionsMenu.get_global_rect())
		is_dragging = false # just in case
		last_val = PlayerPrefs.get_pref("view_scale",1) # stash this early so that the slider doesn't go bonkers
		$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/FullscreenButton.set_pressed_no_signal(OS.window_fullscreen)
		$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/MusicButton.set_pressed_no_signal(PlayerPrefs.get_pref("music", true))
		$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/SFXButton.set_pressed_no_signal(PlayerPrefs.get_pref("sfx", true))
		$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/FPSButton.set_pressed_no_signal(PlayerPrefs.get_pref("show_fps", false))
		$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/Scale/HSlider.value = PlayerPrefs.get_pref("view_scale",1)
		
		GamepadMenu.add_menu(name, menu_items)
	else:
		MovementEvent.remove_deadzone(name)
		GamepadMenu.remove_menu(name)
	$OptionsMenu.visible = state
	$BlurBackground.visible = state


func _on_Done_pressed():
	GameController.OptionsToggle()


func _on_Defaults_pressed():
	AudioPlayer._play_UI_Button_Select()
	$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/FullscreenButton.pressed = true
	$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/MusicButton.pressed = true
	$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/SFXButton.pressed = true
	$OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/Scale/HSlider.value = 1


func _on_CheckButton_toggled(button_pressed):
	AudioPlayer._play_UI_Button_Select()
	GameController.FullscreenToggle()


func _on_MusicButton_toggled(button_pressed):
	PlayerPrefs.set_pref("music", button_pressed)
	AudioPlayer.ChangePlaybackPrefs()
	AudioPlayer._play_UI_Button_Select()


func _on_SFXButton_toggled(button_pressed):
	PlayerPrefs.set_pref("sfx", button_pressed)
	AudioPlayer.ChangePlaybackPrefs()
	AudioPlayer._play_UI_Button_Select()


func _on_HSlider_value_changed(value):
	if !is_dragging:
		if value != last_val:
			last_val = value
			PlayerPrefs.set_pref("view_scale",value)
			GameController.SetViewScale()
			AudioPlayer._play_UI_Button_Select()
	else:
		AudioPlayer._play_UI_Button_Hover()


func _on_HSlider_drag_started():
	is_dragging = true


func _on_HSlider_drag_ended(value_changed):
	is_dragging = false
	#kinda hacky, but it makes drag and select value work w/out shaking the screen with scaling
	_on_HSlider_value_changed($OptionsMenu/OptionsContainer/VBoxContainer/ScrollContainer/OptionList/Scale/HSlider.value)


func _on_FPSButton_toggled(button_pressed):
	AudioPlayer._play_UI_Button_Select()
	PlayerPrefs.set_pref("show_fps", button_pressed)
	DevBuildOverlay.SetFPSCounter(button_pressed)
