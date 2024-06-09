extends Node
# TODO: Entity Loading System, Entity AI

# Update Flags
var frameUpdate = true
var newMap = false

# World Map Variables
var defaultTS = InitData.getTileset("ts1")
var worldDimensions:Array = [100, 100]
var screenDimensions:Array = [71, 21]
var worldMapsPath = "user://Data/Saves/"
var worldMapsSaveID = "debug_world"
var worldMaps:Dictionary = {}
var activeMap = [49,49]

# World System Variables
var worldDate = {"month": 1, "day": 1, "year": 1, "hour": 10, "minute": 15}

# HACK: Load Entities for testing
var plS = load("res://Scenes/player.tscn")
var plI = plS.instantiate()
var entitiesLive = [] 

# HACK: Place a player for testing functions
func _ready():
	#deleteWorldMap(worldMapsPath, worldMapsSaveID)
	#loadWorldMap(worldMapsPath, worldMapsSaveID)
	plI.createNewPlayer("Player", "00ff00")
	plI.setPosition([29,9])
	entitiesLive.append(WorldManager.plI.getPosition())
	add_child(plI)

# Generate World
func createNewWorld(worldDims:Array, path:String, id:String, _seed:int, bar:ProgressBar, msg:Label):
	var _time:Dictionary = Time.get_datetime_dict_from_system()
	print(_time)
	
	# Set up vars for progress updates
	var totalProgress = worldDims[0] * worldDims[1]
	var currentProgress = 0
	
	print(bar)
	print(msg)
	
	msg.text = "Generating Noise"
	
	# Noise Maps
	var altitude:FastNoiseLite = FastNoiseLite.new()
	
	# altitude noise settings
	altitude.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	altitude.seed = _seed
	altitude.frequency = 0.0018
	altitude.fractal_type = FastNoiseLite.FRACTAL_PING_PONG
	altitude.fractal_octaves = 4
	altitude.fractal_lacunarity = 3.160
	altitude.fractal_gain = 0.340
	
	msg.text = "Noise Generated, Building Maps"
	# Iterate map chunks
	for _y in range(worldDims[1]):
		for _x in range(worldDims[0]):
			# Turn map chunk into string
			noiseToMap(altitude, _x, _y, bar, msg)
	# Turn the map Dictionary into a saveable string and save
	msg.text = "Maps Built, Saving World"
	var worldMapsJSONString = JSON.stringify(worldMaps, "\t")
	saveWorldMap(path, id, worldMapsJSONString)
	msg.text = "World Saved"
	# Capture final time and print the times
	_time = Time.get_datetime_dict_from_system()
	print("Done")
	print(_time)

# TODO: Be Better
func noiseToMap(noise:FastNoiseLite, mapX:int, mapY:int, bar, msg):
	# Empty map to start, iter through row by row, col by col
	var _mapString:String = ""
	for _y in range(mapY * screenDimensions[1], (mapY * screenDimensions[1]) + screenDimensions[1]):
		# Start building a row
		var _row:String = ""
		for _x in range(mapX * screenDimensions[0], (mapX * screenDimensions[0]) + screenDimensions[0]):
			# Normalize noise from 0 to 1
			var _val:float = clampf(abs((noise.get_noise_2d(_x, _y)) * 1), 0.0000, 1.0000)
			if _val >= 0.8000:
				_row += "w"
			elif _val >= 0.5500:
				_row += "m"
			elif _val >= 0.4000:
				_row += "f"
			elif _val >= 0.2050:
				_row += "g"
			elif _val >= 0.1050:
				_row += "s"
			else:
				_row += "~"
		# Stick the row to the end of the map string
		_mapString += _row
	# Save finished map to a dict with it's x, y as the key
	worldMaps["{0},{1}".format([mapX, mapY])] = [{"terrain": saveToCharString(_mapString)}]
	msg.text = "Built Map: {0},{1}".format([mapX, mapY])

# Takes the active map and packs it down 
func saveToCharString(_unpackedString:String) -> String:
	var _charString = ""
	InitData.RX.compile(InitData.RXExpressions[1])
	var _rows = InitData.RX.search_all(_unpackedString)
	InitData.RX.compile(InitData.RXExpressions[2])
	for _row in _rows:
		for _strip in InitData.RX.search_all(_row.get_string()):
			if _strip.get_string().length() < 10:
				_charString += _strip.get_string()[0] + "0" + str(_strip.get_string().length())
			else:
				_charString += _strip.get_string()[0] + str(_strip.get_string().length())
	return(_charString)

# Save map to file
func saveWorldMap(path:String, id:String, JSONString:String):
	print("Saving")
	# If the world and dir exist we overwrite
	if FileAccess.file_exists(path + id):
		var saveFile = FileAccess.open(path + id, FileAccess.WRITE)
		saveFile.store_string(JSONString)
	# if not we make the dir and save a new file
	else: 
		DirAccess.make_dir_recursive_absolute(path)
		var saveFile = FileAccess.open(path + id, FileAccess.WRITE)
		saveFile.store_string(JSONString)
		

# Save map to file
func deleteWorldMap(path:String, id:String):
	print("Deleting World")
	# If the world and dir exist we overwrite
	if FileAccess.file_exists(path + id):
		DirAccess.remove_absolute(path + id)
	# if not we make the dir and save a new file
	else: 
		print("No Map To Clear")

# Load a world from file
func loadWorldMap(path:String, id:String):
	print("Loading")
	# If the world exists, just load it
	if FileAccess.file_exists(path + id):
		print("World Exists")
		var _MAP_AS_TEXT = FileAccess.get_file_as_string(path + id)
		worldMaps = JSON.parse_string(_MAP_AS_TEXT)
		EventManager.commandsRecived = []
		return worldMaps

# Place Entities on a map string
func placeEntities(map:String, entities:Array = []):
	for entPos in entities:
		# Get it's position
		var _i = int(entPos[1][0]) + (int(entPos[1][1]) * screenDimensions[0])
		# Special Checks for player
		if entPos[0] == "P":
			# Lambda array, call for direction needed. Returns "g" to allow travel and backstepping
			# out of terrain if stuck after travel
			var tiles = [
				func(): if _i - screenDimensions[0] < 0: return "g" else: return map[_i - screenDimensions[0]],
				func(): if _i + screenDimensions[0] > len(map) - 1: return "g" else: return map[_i + screenDimensions[0]],
				func(): if _i - 1 < 0: return "g" else: return map[_i - 1],
				func(): if _i + 1 > len(map) - 1: return "g" else: return map[_i + 1]
			]
			var collisions = []
			# Index the tiles and call the lambda
			for _tileI in range(tiles.size()):
				var t = tiles[_tileI].call()
				var tileData = InitData.getTileData(defaultTS, "terrain", t)
				# If it fails the terrain check, check entities
				if typeof(tileData) == TYPE_BOOL:
					tileData = InitData.getTileData(defaultTS, "entities", tiles[_tileI])
					# If it's not recognized, assume buffer or something and set false
					if typeof(tileData) == TYPE_BOOL:
						collisions.append(false)
					# Otherwise append the walkable flag
					else:
						collisions.append(tileData["tile_flags"][0]["walkable"])
				# Otherwise append the walkable flag
				else:
					collisions.append(tileData["tile_flags"][0]["walkable"])
			# Pass the collisions to the player for movment checks
			WorldManager.plI.setMoveable(collisions)
		# Set the entity position
		map[_i] = entPos[0]
	# return the updated map
	return map

# Debug func until world autoload is started
func getMap(coords:Array, layer_key:String) -> String:
	return worldMaps["{0},{1}".format(coords)][0][layer_key]

# Vertical world map movement
func moveV(val:int):
	print("Vertical Move")
	print("{0}".format([int(activeMap[1]) + val]))
	if activeMap[1] + val > 0 and activeMap[1] + val < worldDimensions[1]:
		activeMap[1] = activeMap[1] + val
	print(activeMap)
	newMap = true

# Horizontal world map movement
func moveH(val:int):
	print("Horizontal Move")
	print("{0}".format([int(activeMap[0]) + val]))
	if activeMap[0] + val > 0 and activeMap[0] + val < worldDimensions[0]:
		activeMap[0] = activeMap[0] + val
	print(activeMap)
	newMap = true
