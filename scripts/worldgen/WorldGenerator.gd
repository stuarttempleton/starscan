extends Node

export var seedNumber = -1
export var MinStarDistance = 0.05
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

func _ready():
	if (seedNumber < 0):
		 print("World generator seed is negative, choosing a random seed")
	generate(seedNumber if seedNumber >= 0 else randi())

func generate(seednumber):
	var rng = RandomNumberGenerator.new()
	rng.seed = seednumber
	print("Generating world data with seed " + str(seednumber) + "...")
	
	var map = Dictionary()
	map.Stars = generateStars(rng)
	var filename = serializeToFile(map, rng)
	print("...World generated. Saved to file " + filename)
	
func serializeToFile(map, rng):	
	StarMapData.StarMap = map
	var currtime = OS.get_datetime()
	var filename = "res://starmap_data/generated/Generated_" + str(currtime.year) + "-" + str(currtime.month) + "-" + str(currtime.day) + "_" + str(currtime.hour) + "-" + str(currtime.minute) + "-" + str(currtime.second) + "_" + str(rng.seed) + ".json"
	StarMapData.Save(filename)
	return filename
	
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
		star.Name = "System " + str(i+1)
		star.X = positions[i].x
		star.Y = positions[i].y
		star.Scan = false
		star.Planets = generatePlanets(rng, star.Name)
		stars[i] = star
	return stars
		
func generatePlanets(rng, starName):
	var planetCount = rng.randi_range(MinPlanetsPerStar, MaxPlanetsPerStar)
	var planets = []
	planets.resize(planetCount)
	for j in range(planetCount):
		var planet = Dictionary()
		planet.Name = starName + " Planet " + str(j+1)
		planet.Type = Planet.Types[rng.randi_range(0, Planet.Types.size()-1)]
		planet.Size = Planet.Sizes[rng.randi_range(0, Planet.Sizes.size()-1)]
		planet.Ring = (rng.randf() <= RingChance)
		planet.ArtifactCount = randomArtifactCount(rng.randf())
		planet.HazardCount = randomHazardCount(rng.randf())
		planet.ResourceCount = randomResourceCount(rng.randf())
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
