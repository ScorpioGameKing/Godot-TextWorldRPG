extends Node2D

var worldWidth = 100
var worldHeight = 100

var mapWidth = 71
var mapHeight = 21

var realWidth = worldWidth * mapWidth
var realHeight = worldHeight * mapHeight
var worldStringLength = realWidth * realHeight

var mois = FastNoiseLite.new()

var colorGrade = Gradient.new()
@onready var worldTex = $"testTexture"

# Called when the node enters the scene tree for the first time.
func _ready():
	mois.noise_type = FastNoiseLite.TYPE_SIMPLEX_SMOOTH
	mois.seed = 1
	mois.frequency = 0.0018
	mois.fractal_type = FastNoiseLite.FRACTAL_PING_PONG
	mois.fractal_octaves = 4
	mois.fractal_lacunarity = 3.165
	mois.fractal_gain = 0.345
	
	colorGrade.interpolation_color_space = Gradient.GRADIENT_COLOR_SPACE_OKLAB
	colorGrade.add_point(0.00, "0000ff")
	colorGrade.add_point(0.40, "0000ff")
	colorGrade.add_point(0.41, "0000ff")
	colorGrade.add_point(0.42, "cd9a3f")
	colorGrade.add_point(0.45, "cd9a3f")
	colorGrade.add_point(0.51, "38773b")
	colorGrade.add_point(0.64, "38773b")
	colorGrade.add_point(0.65, "4a9b00")
	colorGrade.add_point(0.70, "4a9b00")
	colorGrade.add_point(0.71, "74a592")
	colorGrade.add_point(0.79, "74a592")
	colorGrade.add_point(0.80, "000000")
	colorGrade.add_point(1.00, "000000")
	
	
	
	var moisTex = NoiseTexture2D.new()
	moisTex.normalize = true
	moisTex.color_ramp = colorGrade
	moisTex.width = 1280
	moisTex.height = 1280
	moisTex.noise = mois
	await moisTex.changed
	var moisImg = moisTex.get_image()
	
	worldTex.texture = ImageTexture.create_from_image(moisImg)
	worldTex.texture
	print(mois)
	print(mois.get_noise_2d(0, 0))
	print(mois.get_noise_2d(realWidth, realHeight))

