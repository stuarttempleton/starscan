# WorldGenerator.gd
extends Node


# base vars
export var seedNumber = -1
export var MinStarDistance = 0.04 #0.05
export var MinNebulaDistance = 0.2
#export var MinOutpostDistance = 0.2
#export var TotalArtifacts = 100
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
export var Hostility_Modifier = 0.25
export var MaxTargetTries = 5
export var Sectors_QTY = 25
export var PrimaryCultures_QTY = 3


# Universe generation funcs
func generate_universe(seednumber, prebuilt_sector = null):
	if seednumber < 0:
		print("Universe seed is negative, choosing a random seed")
		seednumber = randi()
	var rng = RandomNumberGenerator.new()
	rng.seed = seednumber
	print("Generating universe data with seed " + str(seednumber) + "...")
	
	var universe = Dictionary()
	universe.UniverseSeed = seednumber
	universe.Sectors = []
	
	for _i in range(Sectors_QTY):
		universe.Sectors.push_back({"MapSeed":rng.randi()})
	if prebuilt_sector:
		universe.Sectors[0] = prebuilt_sector
		universe.Dirty = true #this universe cannot be reconstructed from seed
	else:
		universe.Sectors[0] = generate_sector(universe.Sectors[0].MapSeed)
	
	var filename = serializeToFile(universe, rng)
	print("...universe generated. Saved to file " + filename)
	return universe

func generate_sector(seednumber):
	if seednumber < 0:
		print("Sector seed is negative, choosing a random seed")
		seednumber = randi()
	var rng = RandomNumberGenerator.new()
	rng.seed = seednumber
	print("Generating sector data with seed " + str(seednumber) + "...")
	
	var map = Dictionary()
	map.Systems = generateStars(rng)
	map.Nebulae = generateNebulae(rng)
	map.MapSeed = seednumber
	map.Cultures = generateCultures(rng)
	var culturehomes = select_culturehomes_from_systems(rng, map.Systems, map.Cultures.size(), 0.15)
	var i = 0
	for home in culturehomes:
		home.IsHomeSystem = true
		home.IsControlled = true
		home.Culture = i
		map.Cultures[i].Home = {"X": home.X, "Y": home.Y}
		i += 1
	applyCulturalData(rng, map.Cultures, map.Systems)
	return map
	
func serializeToFile(map, _rng):
	StarMapData.Universe = map
	var _currtime = OS.get_datetime()
	#var filename = "user://Starmap_%04d-%02d-%02d_%02d-%02d-%02d_%s.json" % [currtime.year, currtime.month, currtime.day, currtime.hour, currtime.minute, currtime.second, str(rng.seed)]
	StarMapData.Save(StarMapData.BaseUniverseFile)
	return StarMapData.BaseUniverseFile

func generateCultures(rng):
	var cultures = []
	var qty = PrimaryCultures_QTY
	for i in qty:
		var culture = LanguageGenerator.generate_language_pack(rng.randi())
		culture.TerritoryRadius = rng.randf_range(0.14, 0.16)
		cultures.append(culture)
	return cultures

func applyCulturalData(rng, cultures: Array, systems: Array):
	# Loop through system and apply rules:
	for system in systems:
		
		# DISTANCE: If Distance is less than territory radius, it is owned.
		var system_pos = Vector2(system["X"], system["Y"])
		for i in range(0, PrimaryCultures_QTY): # ONLY primary cultures.
			var home_system_pos = Vector2(cultures[i].Home.X, cultures[i].Home.Y)
			if system_pos.distance_to(home_system_pos) < cultures[i].TerritoryRadius:
				# HOMES: Home systems and contested systems are exempt from these claims
				if !system.IsHomeSystem && !system.IsContested:
					# UNCONTROLLED: if it is not controlled or contested, control it.
					if !system.IsControlled:
						system.IsControlled = true
						system.Culture = i
					# CONTESTED: If already controlled by another culture it is now contested.
					elif system.Culture != i && system.IsControlled:
						system.IsContested = true
						system.IsContestedBy = i
		
		# OUTPOST: If it has an outpost, the outpost gets a random culture
		for planet in system.Planets:
			if planet.Type == "Outpost":
				planet.Culture = rng.randi() % cultures.size()
		
		# UNCLAIMED: If it is not claimed by the territories, it is a random culture.
		if !system.IsControlled && !system.IsContested:
			system.Culture = rng.randi() % cultures.size()

func select_culturehomes_from_systems(rng, systems: Array, num_cultures: int, min_dist: float) -> Array:
	var culturehome := []
	var attempts := 0
	var max_attempts := 1000
	
	while culturehome.size() < num_cultures and attempts < max_attempts:
		var candidate = systems[rng.randi() % systems.size()]
		var candidate_pos = Vector2(candidate["X"], candidate["Y"])
		
		# Make sure we have a suitable planet
		var has_planet := false
		for planet in candidate.Planets:
			if planet.Type != "Outpost":
				has_planet = true
				
		if not has_planet:
			attempts += 1
			continue
		
		# Check distances to make sure we're set.
		var too_close := false
		for home in culturehome:
			var home_pos = Vector2(home["X"], home["Y"])
			if home_pos.distance_to(candidate_pos) < min_dist:
				too_close = true
				break
		
		if has_planet and not too_close:
			culturehome.append(candidate)
		attempts += 1
	print("culture home gen took %d attempts." % [attempts])
	return culturehome

func generateNebulae(rng):
	var posGen = StarPosGenerator.new()
	posGen.MaxTargetTries = MaxTargetTries
	posGen.MinStarDistance = MinNebulaDistance
	var positions = posGen.generate(rng)
	if positions.size() % 2 > 0:
		positions.pop_back()
	var nebCount = positions.size()
	var nebs = []
	nebs.resize(nebCount)
	for i in range(nebCount):
		var neb = Dictionary()
		neb.Name = WordGenerator.Create(rng.randi()).capitalize()
		neb.X = positions[i].x
		neb.Y = positions[i].y
		neb.Scan = 0.0
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
		star.Name = WordGenerator.Create(rng.randi()).capitalize()
		star.X = positions[i].x
		star.Y = positions[i].y
		star.Scan = 0.0
		star.Planets = generatePlanets(rng, star.Name, i)
		star.ContentSeed = rng.randi() # Seed to be used for generating with this star during game play.
		star.IsHomeSystem = false # Set home state to false for all systems
		star.IsContested = false
		star.IsControlled = false
		stars[i] = star
	return stars
		
func generatePlanets(rng, _starName, _starIndex):
	var planetCount = rng.randi_range(MinPlanetsPerStar, MaxPlanetsPerStar)
	var planets = []
	var hasOutposts = false
	
	planets.resize(planetCount)
	for j in range(planetCount):
		var planet = Dictionary()
		planet.Name = WordGenerator.Create(rng.randi()).capitalize()
		planet.Type = StarMapData.PlanetTypes[rng.randi_range(0, StarMapData.PlanetTypes.size()-1)]
		if planet.Type == "Outpost":
			hasOutposts = true
		planet.Size = StarMapData.PlanetSizes[rng.randi_range(0, StarMapData.PlanetSizes.size()-1)]
		planet.Ring = (rng.randf() <= RingChance)
		
		planet.PerceivedArtifactCount = -1
		planet.PerceivedHazardCount = -1
		planet.PerceivedResourceCount = -1
		planet.PerceivedDudCount = -1
		planet.SurfaceSeednumber = rng.randi_range(0, 2147483646)
		planet.RadialOffset = rng.randi_range(25, 60)
		planet.Star = {"Index": _starIndex, "Name": _starName}
		planets[j] = planet
	
	var system_difficulty = -0.25 if hasOutposts else Hostility_Modifier
	
	for planet in planets:
		planet.ArtifactCount = randomArtifactCount(clamp(rng.randf() + system_difficulty, 0.0, 1.0) )
		planet.HazardCount = randomArtifactCount(clamp(rng.randf() + system_difficulty, 0.0, 1.0) )
		planet.ResourceCount = randomArtifactCount(clamp(rng.randf(), 0.0, 1.0) )
		planet.OriginalArtifactCount = planet.ArtifactCount
		planet.OriginalHazardCount = planet.HazardCount
		planet.OriginalResourceCount = planet.ResourceCount
		pass
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
