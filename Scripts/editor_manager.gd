extends Node

var inEditor = false
var activeTileset
var activeBrush = ["terrain", "x"]
var activeTileData

@onready var editorTileName = $MarginContainer/ControlRoot/EditOptM/EditorOptions/BoxContainer/PanelContainer/Rows/Name/TileName
@onready var editorTileSymbol = $MarginContainer/ControlRoot/EditOptM/EditorOptions/BoxContainer/PanelContainer/Rows/Symbol/TileSymbol
@onready var editorTileColor = $MarginContainer/ControlRoot/EditOptM/EditorOptions/BoxContainer/PanelContainer/Rows/Color/TileColor
@onready var editorOptionsTileFlags = $MarginContainer/ControlRoot/EditOptM/EditorOptions/BoxContainer/PanelContainer/Rows/Flags/Label
@onready var tileFlagLabel:Label

func setBrush(_type, _symbol, _data):
	activeBrush = [_type, _symbol]
	activeTileData = _data
	print(activeBrush)
	print(activeTileData)

func setTileInfoDisplay():
	if typeof(activeTileData) != TYPE_NIL:
		print(editorTileName)
		#editorTileName.text = activeTileData["tile_name"]
