extends TextureRect


export var colormap: GradientTexture
const L8_MAX := 255 #8 bit max color


func _ready() -> void:
	_generate(StarMapData.GetRandomPlanetByType("Goldilocks"))


func _generate(planet):
	print("Building map for ", planet.Name, " seed ", planet.SurfaceSeednumber)
	$"../PlanetName".text = planet.Name
	var _seed = planet.SurfaceSeednumber
	var new_noise = OpenSimplexNoise.new()
	new_noise.period = texture.noise.period
	new_noise.octaves = texture.noise.octaves
	new_noise.persistence = texture.noise.persistence
	new_noise.lacunarity = texture.noise.lacunarity
	new_noise.seed = _seed
	
	var new_texture = NoiseTexture.new()
	new_texture.height = texture.get_height()
	new_texture.width = texture.get_width()
	new_texture.noise = new_noise
	
	texture = new_texture
	
	yield(texture, "changed")
	var heightmap_minmax := _get_heightmap_minmax(texture.get_data())
	
	material.set_shader_param("noise_texture", new_texture)
	
	# Use the material's `set_shader_param` method to assign values to a shader's uniforms.
	material.set_shader_param("noise_minmax", heightmap_minmax)
	pass

# gotta normalize the noise data to 0..1
func _get_heightmap_minmax(image: Image) -> Vector2:
	# We convert the image to have a single channel of integer values that go from `0` to `255`.
	image.convert(Image.FORMAT_L8)
	# Gets the lowest and biggest values in the image and divides it to have values between 0 and 1.
	return _get_minmax(image.get_data()) / L8_MAX


# Utility function that returns the minimum and maximum value of an array as a `Vector2`
func _get_minmax(array: Array) -> Vector2:
	var out := Vector2(INF, -INF)
	for value in array:
		out.x = min(out.x, value)
		out.y = max(out.y, value)
	return out
