class_name StarPosGenerator

var MinStarDistance
var MaxTargetTries

var positions
var posCount

func generate(rng):
	# Build an empty square grid sized to hold at most 1 star per grid cell based on minimum distance between stars
	#var cellSize = MinStarDistance / sqrt(2)
	var gridSize = 1.0 / MinStarDistance
	var grid = []
	grid.resize(gridSize)
	for x in range(gridSize):
		grid[x] = []
		grid[x].resize(gridSize)
		
	# Build a Vec2 array to hold the star positions
	positions = []
	positions.resize(pow(gridSize, 2))
	posCount = 0
	
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
			#targetPosition = currentActivePos + vector
			
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
	positions.resize(posCount)
	return positions

func fitVectorToNormalArea(vector):
	var newVector = Vector2(clamp(vector.x, 0.0, 0.999999), clamp(vector.y, 0.0, 0.999999))
	return newVector

func addPosition(targetPosition, grid, gridPos):
	var targetPosIndex = posCount
	positions[targetPosIndex] = targetPosition
	posCount += 1
	# Assign the index of the new position array element to its grid position
	grid[gridPos.x][gridPos.y] = targetPosIndex
	return targetPosIndex
