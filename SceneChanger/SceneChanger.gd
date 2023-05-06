extends CanvasLayer

signal scene_changed(new_scene)
signal fade_in_complete()
signal fade_out_complete()

@onready var animation_player = $AnimationPlayer
@onready var black = $Control/Black

var SceneVars = {}

func LoadScene(path, delay = 0.5, args = {}):
	SceneVars[path] = args
	await get_tree().create_timer(delay).timeout
	animation_player.play("fade")
	await animation_player.animation_finished
	GameController.DisableMap()
	if get_tree().change_scene_to_file(path):
		print("Error loading scene")
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	emit_signal("scene_changed", path)

func FadeToExit(delay = 0.5):
	await get_tree().create_timer(delay).timeout
	animation_player.play("fade")
	await animation_player.animation_finished
	get_tree().quit()

func UnFade(delay = 0.5):
	await get_tree().create_timer(delay).timeout
	animation_player.play_backwards("fade")
	await animation_player.animation_finished
	emit_signal("fade_in_complete")
	print("Done fading...")
	
func Fade(delay = 0.5):
	await get_tree().create_timer(delay).timeout
	animation_player.play("fade")
	await animation_player.animation_finished
	emit_signal("fade_out_complete")

func GoAway():
	animation_player.play_backwards("fade")
