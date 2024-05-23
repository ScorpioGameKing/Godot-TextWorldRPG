extends Node2D

# HACK: Test Gen Width and Height
var screenWidth = 108
var screenHeight = 39

# Default world width and height
@export var worldWidth = 100
@export var worldHeight = 100

# Size of the world view display
var mapWidth = 71
var mapHeight = 21

# Quick ref to the true width height and len
var realWidth = worldWidth * mapWidth
var realHeight = worldHeight * mapHeight
var worldStringLength = realWidth * realHeight

# TODO: Intial Noise map, reuse as a altitude map and add temp/moisture
var mois = FastNoiseLite.new()

# Create the gradient to  clamp values, posibbly have to rework manually
var colorGrade = Gradient.new()

# Ref to the texture to display raw noise and text conversion
@onready var worldTex = $"testTexture"
@onready var worldStr = $"RichTextLabel"

# TODO: Load tileset for gen, eventually determined by biome 
@onready var mapTS = InitData.getTileset("ts1")

# Test building noise and calc the render time
func _ready():
	var stime = Time.get_datetime_dict_from_system()
	
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
	var moisTex = NoiseTexture2D.new()
	moisTex.normalize = true
	moisTex.width = realWidth
	moisTex.height = realHeight
	moisTex.noise = mois
	moisTex.color_ramp = colorGrade
	
	# wait for changes to be complete, it's threaded
	await moisTex.changed
	
	# Pull the img and index a chunk from 0,0 to test gen dimensions
	var moisImg = moisTex.get_image()
	for _y in range(screenHeight - 1):
		for _x in range(screenWidth - 1):
			var _c
			# HACK: Unsure why but 0,0 fails, hacky grab next tile
			if _x == 0 and _y == 0: 
				_c = moisImg.get_pixel(_x + 1,_y).to_html(false)
			else:
				_c = moisImg.get_pixel(_x,_y).to_html(false)
			# Check the color value and add either tile or buffer depending
			var _sym = InitData.colorToTile(mapTS, "terrain", _c)
			if typeof(_sym) == TYPE_STRING:
				worldStr.text += "[color=" + _c + "]" + _sym + "[/color]"
			else:
				worldStr.text += "X"
		# Wrap the line
		worldStr.text += "\n"
	
	# Render the raw noise
	#worldTex.texture = ImageTexture.create_from_image(moisImg)
	
	# Capture final time and print the times
	var etime = Time.get_datetime_dict_from_system()
	print(stime)
	print(etime)

