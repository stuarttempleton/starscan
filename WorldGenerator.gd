extends Node

export var seedNumber = -1
export var MinStarDistance = 0.05
export var MinOutpostDistance = 0.2
export var TotalArtifacts = 100
export var MinPlanetsPerStar = 1
export var MaxPlanetsPerStar = 6
export var MinPlanetArtifacts = 0
export var MaxPlanetArtifacts = 3
export var MinPlanetResources = 0
export var MaxPlanetResources = 3
export var MinHazard = 0
export var MaxHazard = 3
export var MaxTargetTries = 5

var posCount
var positions

# Called when the node enters the scene tree for the first time.
func _ready():
	if (seedNumber < 0):
		 print("World generator seed is negative, choosing a random seed")
	generate(seedNumber if seedNumber >= 0 else randi())
	#generate(3161026589)


# Called every frame. 'delta' is the elapsed time since the previous frame.
#func _process(delta):
#	pass

func generate(seednumber):
	var rng = RandomNumberGenerator.new()
	rng.seed = seednumber
	print("Generating world data with seed " + str(seednumber) + "...")
	
	generateStarPositions(rng)
	
	var map = Dictionary()
	var systems = []
	systems.resize(posCount)
	for i in range(posCount):
		var system = Dictionary()
		system["Name"] = "System " + str(i+1)
		system["X"] = positions[i].x
		system["Y"] = positions[i].y
		system["Scan"] = false
		#TODO: planets
		systems[i] = system
	map["Systems"] = systems
	#print("Generated world data: " + str(map))
	
	StarMapData.StarMap = map
	var filename = "res://starmap_data/Generated_" + str(seednumber) + ".json"
	StarMapData.Save(filename)
	print("...World generated. Saved to file " + filename)
	
func generateStarPositions(rng):
	#print("Generating star positions.")
	# Build an empty square grid sized to hold at most 1 star per grid cell based on minimum distance between stars
	#var cellSize = MinStarDistance / sqrt(2)
	var gridSize = 1.0 / MinStarDistance
	#print("\tGrid is " + str(gridSize) + " cells square.")
	var grid = []
	grid.resize(gridSize)
	for x in range(gridSize):
		grid[x] = []
		grid[x].resize(gridSize)
		
	# Build a Vec2 array to hold the star positions
	posCount = 0
	positions = []
	positions.resize(pow(gridSize, 2))
	#print("Position array size " + str(positions.size()))
	
	# Build a list to point to the "active" star positions
	var activePositionIndices = PoolIntArray([])
	
	# Create a var to target the position the next star should be created at
	# Initialize the target position to a random Vec2
	var targetPosition = fitVectorToNormalArea(Vector2(rng.randf(), rng.randf()))
	# Find the grid cell containing the target position
	var targetGridPos = Vector2(int(targetPosition.x / MinStarDistance), int(targetPosition.y / MinStarDistance))
	# Add the target position to the set of positions and active positions, and update the grid
	var targetPosIndex = addPosition(targetPosition, grid, targetGridPos)
	# Add index of the new position array element to the active positions list
	activePositionIndices.append(targetPosIndex)
	#print("\t\t\tactivePositionIndices size: " + str(activePositionIndices.size()) + ", contents: " + str(activePositionIndices))
	
	# while there are still active positions:
	while activePositionIndices.size() > 0:
		
		# Select a random active position
		var indexIndex = rng.randi_range(0, activePositionIndices.size() - 1)
		var currentActivePosIndex = activePositionIndices[indexIndex]
		var currentActivePos = positions[currentActivePosIndex]
		#print("\tAttempting to fit a new neighbor near (" + str(currentActivePos.x) + "," + str(currentActivePos.y) + ").")
		
		# Try creating random neighbors until one is legal (keep it) or too many attempts fail (deactivate the current active position)
		for _i in range(MaxTargetTries):
			
			# Pick a new point in a random direction from the active position, at a random distance between MinStarDistance and twice that
			var vectorLength = rng.randf_range(MinStarDistance, 2*MinStarDistance)
			var vectorAngle = rng.randf_range(0, 2*PI)
			var vector = Vector2(0, vectorLength).rotated(vectorAngle)
			targetPosition = fitVectorToNormalArea(currentActivePos + vector)
			
			# Find the grid cell the new point belongs to
			targetGridPos = Vector2(int(targetPosition.x / MinStarDistance), int(targetPosition.y / MinStarDistance))
			
			# Check positions in nearby grid cells to see if any contain a point too close to the new target position
			var targetIsIllegal = false
			if grid[targetGridPos.x][targetGridPos.y] != null || grid[targetGridPos.x][targetGridPos.y] == 0:
				# The target point's cell already has a point, abandon the current target and continue to next iteration
				targetIsIllegal = true
			else:
				# Check the target point's neighbors to see if any are too close
				for gridX in range(max(0, targetGridPos.x - 2), min(gridSize-1, targetGridPos.x + 2)):
					for gridY in range(max(0, targetGridPos.y - 2), min(gridSize-1, targetGridPos.y + 2)):
						var neighborGridPos = Vector2(gridX, gridY)
						if grid[neighborGridPos.x][neighborGridPos.y] == null:
							# There's not a point in this cell, look in the next cell for a neighbor
							continue
						var targetNeighbor = positions[grid[neighborGridPos.x][neighborGridPos.y]]
						
						if targetNeighbor.distance_to(targetPosition) < MinStarDistance:
							# An existing point is closer than MinStarDistance to the current target, abandon current target
							targetIsIllegal = true
							break # Exit y loop
					# End of y loop
					if targetIsIllegal:
						break # Exit x loop
				# End of x loop
			
			if targetIsIllegal:
				targetPosition = null
				continue
			else:
				# A valid target is found, no need to try additional targets
				break
		#End of target try loop
			
		if targetPosition != null:
			# A valid target position is found, add it to the set of valid positions
			targetPosIndex = addPosition(targetPosition, grid, targetGridPos)
			# Add index of the new position array element to the active positions list
			activePositionIndices.append(targetPosIndex)
			# Clear the target position
			targetPosition = null
		else:
			# Remove the current active position from the active positions list
			activePositionIndices.remove(indexIndex)
			#print("\t\tExhausted attempts to fit a new neighbor near (" + str(currentActivePos.x) + "," + str(currentActivePos.y) + "). Deactivating it.")
		
		#print("\t\t" + str(activePositionIndices.size()) + " active positions remain. Moving to the next active position.")
	# End of active position loop
	#print("\tNo active positions remain, star position generation is complete.")
	#print("\tPositions generated: " + str(positions))

func fitVectorToNormalArea(vector):
	var newVector = Vector2(clamp(vector.x, 0.0, 0.999999), clamp(vector.y, 0.0, 0.999999))
	#if vector.x < 0 || vector.x >= 1 || vector.y < 0 || vector.y >= 1:
	#	print("\t\t\tVector (" + str(vector.x) + "," + str(vector.y) + ") doesn't fit in a normal area, clamping it to (" + str(newVector.x) + "," + str(newVector.y) + ").")
	return newVector

func addPosition(targetPosition, grid, gridPos):
	#print("\t\tAdding position (" + str(targetPosition.x) + "," + str(targetPosition.y) + "), grid cell (" + str(gridPos.x) + "," + str(gridPos.y) + "). There are now " + str(posCount+1) + " positions.")
	var targetPosIndex = posCount
	positions[targetPosIndex] = targetPosition
	posCount += 1
	# Assign the index of the new position array element to its grid position
	#print("\t\t\tGrid cell content is currently " + str(grid[gridPos.x][gridPos.y]))
	grid[gridPos.x][gridPos.y] = targetPosIndex
	return targetPosIndex
