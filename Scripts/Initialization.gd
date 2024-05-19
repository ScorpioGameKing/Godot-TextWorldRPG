extends Node

# Refrences to tile data, only should use findTileData for access
static var _TILE_PATH = "res://Data/tile_data.json"
static var _TILE_AS_TEXT = FileAccess.get_file_as_string(_TILE_PATH)
static var TILE_DICT = JSON.parse_string(_TILE_AS_TEXT)

# References to map data, only should use getMap for access
var _MAP_PATH = "res://Data/map_data.json"
var _MAP_AS_TEXT = FileAccess.get_file_as_string(_MAP_PATH)
var MAP_DICT = JSON.parse_string(_MAP_AS_TEXT)

# References to command data, only should use getTokens for access
static var _CMD_PATH = "res://Data/command_data.json"
static var _CMD_AS_TEXT = FileAccess.get_file_as_string(_CMD_PATH)
static var CMD_DICT = JSON.parse_string(_CMD_AS_TEXT)

# World variables such as defualt buffer/map size, the worldMapGrid
static var worldBufferDims = [71, 21]

# Intial states of globals, will be be updated from save file on loads
var worldMonth = 5
var worldDay = 25
var worldHour = 10
var worldMin = 15

# Debug holder vars
var mapTS

# REGEX Tools
static var RX = RegEx.new()
static var RXExpressions = [
	r'([a-zA-Z~][0-9]{2})', # Reads a packed character string
	r'(.{71})', # Splits string by row width
	r'([a-z~A-Z])\1*', # Grabs strips of same characters
	r'([0-9:)]{6})', # Grabs Time from input commands
	r'(\w+)', # Tokenize Command String
	r'([0-9:)]{6})\s([a-zA-Z].*)' # Group 1 Time, Group 2 Command String
]

# Debug Functions here, eventually this will load data from saves
func _ready():
	mapTS = getTileset("ts1")
	#print(mapTS, "terrain", "f")

func getTileset(tileset:String):
	return TILE_DICT[tileset][0]

func getTileData(tileset:Dictionary, type:String, symbol:String):
	for _tile in tileset[type]:
		if _tile["tile_data"][0]["tile_symbol"] == symbol:
			return _tile["tile_data"][0]
	return false

# Hacky but generally useful, returns key + 1: value as long as you have a count
func getNextDictValue(index:int, dict:Dictionary):
	return dict.values()[index + 1]
	
# Debug func until world autoload is started
func getMap(coords:Array, layer_key:String) -> String:
	return MAP_DICT["{0},{1}".format(coords)][0][layer_key]
	
func getToken(alias:String):
	for _token in CMD_DICT["tokens"]:
		if alias.matchn(_token["alias"][0]):
			var _data = getNextDictValue(0, _token)
			return [alias, _data]
