extends CanvasLayer

signal scene_changed()
signal fade_in_complete()
signal fade_out_complete()

onready var animation_player = $AnimationPlayer
onready var black = $Control/Black

func LoadScene(path, delay = 0.5):
	yield(get_tree().create_timer(delay),"timeout")
	animation_player.play("fade")
	yield(animation_player,"animation_finished")
	GameController.DisableMap()
	if get_tree().change_scene(path):
		print("Error loading scene")
	animation_player.play_backwards("fade")
	yield(animation_player,"animation_finished")
	emit_signal("scene_changed")

func FadeToExit(delay = 0.5):
	yield(get_tree().create_timer(delay),"timeout")
	animation_player.play("fade")
	yield(animation_player,"animation_finished")
	get_tree().quit()

func UnFade(delay = 0.5):
	yield(get_tree().create_timer(delay),"timeout")
	animation_player.play_backwards("fade")
	yield(animation_player,"animation_finished")
	emit_signal("fade_in_complete")
	
func Fade(delay = 0.5):
	yield(get_tree().create_timer(delay),"timeout")
	animation_player.play("fade")
	yield(animation_player,"animation_finished")
	emit_signal("fade_out_complete")

func GoAway():
	animation_player.play_backwards("fade")
