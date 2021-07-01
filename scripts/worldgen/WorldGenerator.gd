extends Node

export var seedNumber = -1
export var MinStarDistance = 0.05
export var MinNebulaDistance = 0.2
export var MinOutpostDistance = 0.2
export var TotalArtifacts = 100
export var MinPlanetsPerStar = 1
export var MaxPlanetsPerStar = 6
export var RingChance = 0.1
export var Resource0_Chance = 0.5
export var Resource1_Chance = 0.3
export var Resource2_Chance = 0.15
export var Resource3_Chance = 0.05
export var Hazard0_Chance = 0.2
export var Hazard1_Chance = 0.4
export var Hazard2_Chance = 0.3
export var Hazard3_Chance = 0.1
export var Artifact0_Chance = 0.6
export var Artifact1_Chance = 0.2
export var Artifact2_Chance = 0.15
export var Artifact3_Chance = 0.05
export var MaxTargetTries = 5

export var NameGenerationNodePath = ""
var NameGenerator

func _ready():
	NameGenerator = $"/root/StoryGenerator/WordGenerator"

func generate(seednumber):
	if seednumber < 0:
		print("World generator seed is negative, choosing a random seed")
		seednumber = randi()
	var rng = RandomNumberGenerator.new()
	rng.seed = seednumber
	print("Generating world data with seed " + str(seednumber) + "...")
	
	var map = Dictionary()
	map.Systems = generateStars(rng)
	map.Nebulae = generateNebulae(rng)
	map.MapSeed = seednumber
	var filename = serializeToFile(map, rng)
	print("...World generated. Saved to file " + filename)
	
func serializeToFile(map, rng):	
	StarMapData.StarMap = map
	var currtime = OS.get_datetime()
	var filename = "user://Starmap_%04d-%02d-%02d_%02d-%02d-%02d_%s.json" % [currtime.year, currtime.month, currtime.day, currtime.hour, currtime.minute, currtime.second, str(rng.seed)]
	
	StarMapData.Save(filename)
	return filename

func generateNebulae(rng):
	var posGen = StarPosGenerator.new()
	posGen.MaxTargetTries = MaxTargetTries
	posGen.MinStarDistance = MinNebulaDistance
	var positions = posGen.generate(rng)
	var nebCount = positions.size()
	var nebs = []
	nebs.resize(nebCount)
	for i in range(nebCount):
		var neb = Dictionary()
		neb.Name = NameGenerator.CreateWord().capitalize()
		neb.X = positions[i].x
		neb.Y = positions[i].y
		neb.Size = StarMapData.PlanetSizes[rng.randi_range(0, StarMapData.PlanetSizes.size()-1)]
		nebs[i] = neb
	return nebs
	
func generateStars(rng):
	var posGen = StarPosGenerator.new()
	posGen.MaxTargetTries = MaxTargetTries
	posGen.MinStarDistance = MinStarDistance
	var positions = posGen.generate(rng)
	var starCount = positions.size()
	var stars = []
	stars.resize(starCount)
	for i in range(starCount):
		var star = Dictionary()
		star.Name = NameGenerator.CreateWord().capitalize()
		star.X = positions[i].x
		star.Y = positions[i].y
		star.Scan = 0.0
		star.Planets = generatePlanets(rng, star.Name)
		stars[i] = star
	return stars
		
func generatePlanets(rng, starName):
	var planetCount = rng.randi_range(MinPlanetsPerStar, MaxPlanetsPerStar)
	var planets = []
	planets.resize(planetCount)
	for j in range(planetCount):
		var planet = Dictionary()
		planet.Name = NameGenerator.CreateWord().capitalize()
		planet.Type = StarMapData.PlanetTypes[rng.randi_range(0, StarMapData.PlanetTypes.size()-1)]
		planet.Size = StarMapData.PlanetSizes[rng.randi_range(0, StarMapData.PlanetSizes.size()-1)]
		planet.Ring = (rng.randf() <= RingChance)
		planet.ArtifactCount = randomArtifactCount(rng.randf())
		planet.HazardCount = randomHazardCount(rng.randf())
		planet.ResourceCount = randomResourceCount(rng.randf())
		planet.OriginalArtifactCount = planet.ArtifactCount
		planet.OriginalHazardCount = planet.HazardCount
		planet.OriginalResourceCount = planet.ResourceCount
		planet.PerceivedArtifactCount = -1
		planet.PerceivedHazardCount = -1
		planet.PerceivedResourceCount = -1
		planet.PerceivedDudCount = -1
		planet.SurfaceSeednumber = rng.randi_range(0, 2147483646)
		planet.RadialOffset = rng.randi_range(25, 60)
		planets[j] = planet
	return planets
	
func randomArtifactCount(dieRoll):
	var threshold = Artifact0_Chance
	if dieRoll <= threshold: return 0
	threshold += Artifact1_Chance
	if dieRoll <= threshold: return 1
	threshold += Artifact2_Chance
	if dieRoll <= threshold: return 2
	threshold += Artifact3_Chance
	if threshold > 1.001: print("Sum of Artifact chances (" + str(threshold) + ") exceeds 1.0, that's a Bad Thing")
	return 3
	
func randomHazardCount(dieRoll):
	var threshold = Hazard0_Chance
	if dieRoll <= threshold: return 0
	threshold += Hazard1_Chance
	if dieRoll <= threshold: return 1
	threshold += Hazard2_Chance
	if dieRoll <= threshold: return 2
	threshold += Hazard3_Chance
	if threshold > 1.001: print("Sum of Hazard chances (" + str(threshold) + ") exceeds 1.0, that's a Bad Thing")
	return 3
	
func randomResourceCount(dieRoll):
	var threshold = Resource0_Chance
	if dieRoll <= threshold: return 0
	threshold += Resource1_Chance
	if dieRoll <= threshold: return 1
	threshold += Resource2_Chance
	if dieRoll <= threshold: return 2
	threshold += Resource3_Chance
	if threshold > 1.001: print("Sum of Resource chances (" + str(threshold) + ") exceeds 1.0, that's a Bad Thing")
	return 3
