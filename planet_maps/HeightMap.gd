extends TextureRect

export(NodePath) var PointsOfInterest_path
var PointsOfInterest

export var colormap: GradientTexture
const L8_MAX := 255 #8 bit max color


export var PlanetGradientMaps = {
	"Gas":"res://planet_maps/gas_planet_surface_gradient.tres",
	"Ice":"res://planet_maps/ice_planet_surface_gradient.tres",
	"Lava":"res://planet_maps/lava_planet_surface_gradient.tres",
	"Goldilocks":"res://planet_maps/goldilocks_planet_surface_gradient.tres",
	"Desert":"res://planet_maps/desert_planet_surface_gradient.tres",
	"Ocean":"res://planet_maps/ocean_planet_surface_gradient.tres",
	"Asteroid Belt":"res://planet_maps/asteroid_planet_surface_gradient.tres",
	"Comet":"res://planet_maps/comet_planet_surface_gradient.tres",
	"Outpost":"res://planet_maps/asteroid_planet_surface_gradient.tres"
}

func _ready() -> void:
	PointsOfInterest = get_node(PointsOfInterest_path)


func _generate(planet, scan):
	print("Building map for ", planet.Name, " seed ", planet.SurfaceSeednumber)
	print("Scan: ", scan)
	
	var planet_texture_gradient = GradientTexture.new()
	planet_texture_gradient.gradient = load(PlanetGradientMaps[planet.Type])
	
	var new_noise = OpenSimplexNoise.new()
	new_noise.period = texture.noise.period
	new_noise.octaves = texture.noise.octaves
	new_noise.persistence = texture.noise.persistence
	new_noise.lacunarity = texture.noise.lacunarity
	new_noise.seed = planet.SurfaceSeednumber
	
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
	material.set_shader_param("colormap", planet_texture_gradient)
	if planet.Type == "Outpost":
		PointsOfInterest.ClearPOINodes()
		$"../../OutpostDialog".DialogBegin(planet)
	else:
		PointsOfInterest._generate(planet, scan)
		$"../../PlanetDialog".DialogBegin(planet)
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
