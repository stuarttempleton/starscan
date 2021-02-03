extends Node2D



func _ready():
	var verts = GenerateVerts(4)


func NewOffset():
	randomize()
	return rand_range(5,100) * rand_range(-1,1)

	
func GenerateVerts(num):
	var vectors = PoolVector2Array()
	
	for i in num:
		vectors.append(Vector2(10 + NewOffset(), 10 + NewOffset()))
	return vectors

