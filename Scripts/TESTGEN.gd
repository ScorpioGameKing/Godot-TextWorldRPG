extends Node2D

# HACK: Test Gen Width and Height
var screenWidth:int = 108
var screenHeight:int = 39

# Default world width and height
@export var worldWidth:int = 100
@export var worldHeight:int = 100

# Size of the world view display
var mapWidth:int = 71
var mapHeight:int = 21

# Quick ref to the true width height and len
var realWidth:int = worldWidth * mapWidth
var realHeight:int = worldHeight * mapHeight
var worldStringLength:int = realWidth * realHeight

var worldMapsPath = "user://Data/Saves/"
var WorldMapsSaveID = "debug_world.json"

# References to map data, only should use getMap for access
var MAP_DICT

# TODO: Intial Noise map, reuse as a altitude map and add temp/moisture
var mois:FastNoiseLite = FastNoiseLite.new()

# Create the gradient to  clamp values, posibbly have to rework manually
var colorGrade:Gradient = Gradient.new()

# Ref to the texture to display raw noise and text conversion
@onready var worldTex = $"testTexture"
@onready var worldStr = $"RichTextLabel"

# TODO: Load tileset for gen, eventually determined by biome 
@onready var mapTS = InitData.getTileset("ts1")

@onready var worldMaps:Dictionary = {}

# Test building noise and calc the render time
func _ready():
	var _time:Dictionary = Time.get_datetime_dict_from_system()
	print(_time)
	
	# Clear anything previous just in case
	worldStr.text = ""
	
	# altitude noise settings
	mois.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	mois.seed = 1
	mois.frequency = 0.0018
	mois.fractal_type = FastNoiseLite.FRACTAL_PING_PONG
	mois.fractal_octaves = 4
	mois.fractal_lacunarity = 3.165
	mois.fractal_gain = 0.345
	
	# Hard step, constant value interplation gradient to set pixel colors to tile colors
	colorGrade.interpolation_color_space = Gradient.GRADIENT_COLOR_SPACE_OKLAB
	colorGrade.interpolation_mode = Gradient.GRADIENT_INTERPOLATE_CONSTANT
	colorGrade.add_point(0.00, "1b85b8") # Water
	colorGrade.add_point(0.39, "1b85b8")
	colorGrade.add_point(0.39, "ffe8a3") # Sand
	colorGrade.add_point(0.43, "ffe8a3")
	colorGrade.add_point(0.43, "1e6649") # Grass
	colorGrade.add_point(0.65, "1e6649")
	colorGrade.add_point(0.65, "6a8758") # Forest
	colorGrade.add_point(0.75, "6a8758")
	colorGrade.add_point(0.75, "5c8084") # Mountain
	colorGrade.add_point(0.90, "5c8084")
	colorGrade.add_point(0.90, "ffffff") # Snow
	colorGrade.add_point(1.00, "ffffff")
	
	# Generate the texture at the desired size then apply gradient
	var moisTex:NoiseTexture2D = NoiseTexture2D.new()
	moisTex.normalize = true
	moisTex.width = realWidth
	moisTex.height = realHeight
	moisTex.noise = mois
	moisTex.color_ramp = colorGrade
	
	# wait for changes to be complete, it's threaded
	print("Waiting for Texture")
	await moisTex.changed
	
	# Pull the img and index a chunk from 0,0 to test gen dimensions
	print("Pulling Image")
	var moisImg:Image = moisTex.get_image()
	
	# Either render Raw or text
	#textRender(moisImg)
	worldTex.texture = ImageTexture.create_from_image(moisImg)
	
	for _y in range(worldHeight):
		for _x in range(worldWidth):
			noiseToMap(mois, _x, _y)
	print(worldMaps.size())
	
	
	var worldMapsJSONString = JSON.stringify(worldMaps, "\t")
	#print(worldMapsJSONString)
	saveWorldMap(worldMapsPath, WorldMapsSaveID, worldMapsJSONString)
	loadWorldMap(worldMapsPath, WorldMapsSaveID)
	print(MAP_DICT)
	
	# Capture final time and print the times
	_time = Time.get_datetime_dict_from_system()
	print("Done")
	print(_time)
	
func saveWorldMap(path:String, id:String, JSONString:String):
	if FileAccess.file_exists(path + id):
		var saveFile = FileAccess.open(path + id, FileAccess.WRITE)
		saveFile.store_string(JSONString)
	else: 
		DirAccess.make_dir_recursive_absolute(path)
		var saveFile = FileAccess.open(path + id, FileAccess.WRITE)
		saveFile.store_string(JSONString)

func loadWorldMap(path:String, id:String):
	if FileAccess.file_exists(path + id):
		var _MAP_AS_TEXT = FileAccess.get_file_as_string(path + id)
		MAP_DICT = JSON.parse_string(_MAP_AS_TEXT)
	else: 
		print("No File")

# TODO: Be Better
func noiseToMap(noise:FastNoiseLite, mapX:int, mapY:int):
	var _mapString:String = ""
	for _y in range(mapY * mapHeight, (mapY * mapHeight) + mapHeight):
		var _row:String = ""
		for _x in range(mapX * mapWidth, (mapX * mapWidth) + mapWidth):
			var _val:float = clampf(abs((noise.get_noise_2d(_x, _y) * 2)), 0.0, 1.0)
			if _val >= 0.90:
				_row += "w"
			elif _val >= 0.75:
				_row += "m"
			elif _val >= 0.55:
				_row += "f"
			elif _val >= 0.25:
				_row += "g"
			elif _val >= 0.15:
				_row += "s"
			else:
				_row += "~"
		_mapString += _row
	worldMaps["{0},{1}".format([mapX, mapY])] = [{"terrain": saveToCharString(_mapString)}]

# Takes the active map and packs it down 
func saveToCharString(_unpackedString:String) -> String:
	#print("Saved Map String")
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
