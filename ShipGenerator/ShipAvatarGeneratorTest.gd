extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"


# Called when the node enters the scene tree for the first time.
func _ready():
	SceneChanger.GoAway()

func _on_Button_pressed():
	print("Generating new ship")
	$ShipGenerator._generate(-1)
