extends Node

# Refrences to tile data, only should use findTileData for access
static var _TILE_PATH = "res://Highlighters/tile_data.json"
static var _TILE_AS_TEXT = FileAccess.get_file_as_string(_TILE_PATH)
static var TILE_DICT = JSON.parse_string(_TILE_AS_TEXT)

# World variables such as defualt buffer/map size, the worldMapGrid
static var worldBufferDims = [71, 21]

# Intial states of globals, will be be updated from save file on loads
static var worldMonth = 5
static var worldDay = 25
static var worldHour = 10
static var worldMin = 15


# Extracts the Tile data for things like color and map generation (WIP)
func findTileData(biome:String, _char:String):
	var _bKey = 0
	for _biome in TILE_DICT:
		if typeof(TILE_DICT[_biome]) == TYPE_STRING and TILE_DICT[_biome] == biome:
			var _tKey = 0
			for _sym in getNextDictValue(_bKey, TILE_DICT):
				if typeof(_sym["tile_symbol"]) == TYPE_STRING and _sym["tile_symbol"] == _char:
					return getNextDictValue(_tKey, _sym)
			_tKey += 1
		else:
			return [false]
		_bKey += 1

# Hacky but generally useful, returns key + 1: value as long as you have a count
func getNextDictValue(index:int, dict:Dictionary):
	return dict.values()[index + 1]
