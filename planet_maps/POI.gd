extends Node2D


# Declare member variables here. Examples:
# var a = 2
# var b = "text"

var poi_types = ["Artifact","Resource","Hazard", "Empty"]
var poi_node = ""

func _ready():
	$ClickArea.connect("selected", self, "selected")
	$ClickArea.connect("hover", self, "hover")
	$ClickArea.connect("unhover", self, "unhover")

func hover(hover_position):
	print(get_parent().get_parent().get_parent().get_parent().get_parent().name)
	get_parent().get_parent().get_parent().get_parent().get_parent().POIHover(hover_position)
	pass


func unhover():
	get_parent().get_parent().get_parent().get_parent().get_parent().POIUnhover()
	pass


func selected():
	get_parent().get_parent().get_parent().get_parent().get_parent().POISelect()
	pass


func SetPOIInfo(poi_type):
	for _p in poi_types:
		get_node(_p).visible = false
	poi_node = get_node(poi_type)
	poi_node.visible = true
