extends Node

var inEditor = false
var activeTileset
var activeBrush = ["terrain", "x"]
var activeTileData

var editorTileName
var editorTileSymbol
var editorTileColor
var editorOptionsTileFlags
var updateTileInfo = false

func loadEditor():
	get_tree().change_scene_to_file("res://Scenes/map_builder_root.tscn")
	inEditor = true

func setBrush(_type, _symbol, _data):
	activeBrush = [_type, _symbol]
	activeTileData = _data
	print(activeBrush)
	print(activeTileData)

func setTileInfoDisplay(data:Dictionary):
	editorTileName = data["tile_name"]
	editorTileSymbol = data["tile_symbol"]
	editorTileColor = data["tile_color"]
	editorOptionsTileFlags = data["tile_flags"][0]
	print(editorTileName, editorTileSymbol, editorTileColor, editorOptionsTileFlags)
	updateTileInfo = true
