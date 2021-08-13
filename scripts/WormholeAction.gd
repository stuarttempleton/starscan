extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

enum State{
	Nothing,
	ScaleDown,
	JumpLocation,
	ScaleUp
}
var CurrentState = State.Nothing
var scale_rate = 3.0
var fade_rate = 3.0
var rotation_rate = 20.0
var max_lerp = 1.0
var min_lerp = 0.0

var avatar
var jump_location

func _ready():
	avatar = get_parent()

func EnterWormholeTo(target):
	if CurrentState == State.Nothing:
		jump_location = target
		CurrentState = State.ScaleDown
		avatar.look_enabled = false
		AudioPlayer.PlaySFX(AudioPlayer.AUDIO_KEY.ANOMALY_TRAVEL)
		SceneChanger.Fade(0)


func _process(delta):
	match CurrentState:
		State.ScaleDown:
			avatar.modulate.a = clamp(avatar.modulate.a - delta * fade_rate, min_lerp, max_lerp)
			avatar.scale.x = clamp(avatar.scale.x - delta * scale_rate, min_lerp, max_lerp)
			avatar.scale.y = clamp(avatar.scale.y - delta * scale_rate, min_lerp, max_lerp)
			if avatar.modulate.a == 0:
				CurrentState = State.JumpLocation
		State.JumpLocation:
			avatar.JumpToMapPosition(jump_location)
			CurrentState = State.ScaleUp
			SceneChanger.UnFade(0)
		State.ScaleUp:
			avatar.modulate.a = clamp(avatar.modulate.a + delta * fade_rate, min_lerp, max_lerp)
			avatar.scale.x = clamp(avatar.scale.x + delta * scale_rate, min_lerp, max_lerp)
			avatar.scale.y = clamp(avatar.scale.y + delta * scale_rate, min_lerp, max_lerp)
			if avatar.modulate.a == 1:
				CurrentState = State.Nothing
				avatar.look_enabled = true
	if CurrentState != State.Nothing:
		avatar.rotate(delta * rotation_rate * -1)
