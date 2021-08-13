extends Node2D

func _ready():
	SceneChanger.UnFade()

func _on_Reveal_pressed():
	$Wormhole.Appear()

func _on_Hide_pressed():
	$Wormhole.Disappear()
