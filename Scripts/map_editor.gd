extends Node2D

@onready var editorTile = preload("res://Scenes/editor_tile.tscn")
@onready var selectTile = preload("res://Scenes/select_tile.tscn")
@onready var tileGrid:Dictionary = {}
@onready var tilesetSelector:OptionButton = $MarginContainer/ControlRoot/MapM/MapOptions/MapVerticalBox/MapPanel/ScrollContainer/MapSettings/Tileset/TilesetSelector
@onready var tileSelector:OptionButton = $MarginContainer/ControlRoot/TileM/TileOptions/Organizer/TilesBG/HOrganizer/TileMetaOpt/TileTypeSelection
@onready var tileOrganizer:HBoxContainer = $MarginContainer/ControlRoot/TileM/TileOptions/Organizer/TilesBG/HOrganizer/TileScrollSelect/TileOrganizer
var curTiles:String = ""
var displayTiles:Array = []
var mapDims:Array = [71, 21]


func _ready():
	initMapGrid()
	initTileSelector(EditorManager.activeTileset)
	curTiles = tileSelector.get_item_text(tileSelector.selected)
	tilesToDisplay(EditorManager.activeTileset)
	print(curTiles)
	
func _process(_delta):
	if curTiles != tileSelector.get_item_text(tileSelector.selected):
		curTiles = tileSelector.get_item_text(tileSelector.selected)
		print(curTiles)
		tilesToDisplay(EditorManager.activeTileset)

func initTileSelector(_ts):
	for tile in _ts:
		print(tile)
		tileSelector.add_item(tile)

func tilesToDisplay(_ts):
	for _child in displayTiles:
		_child.queue_free()
	displayTiles = []
	for _i in _ts[curTiles].size():
		print(_ts[curTiles][_i])
		displayTiles.append(selectTile.instantiate())
		tileOrganizer.add_child(displayTiles[_i])
		displayTiles[_i].setTile(_ts, curTiles, _ts[curTiles][_i]["tile_data"][0]["tile_symbol"])

# Generate New Map grid
func initMapGrid():
	EditorManager.activeTileset = InitData.getTileset(tilesetSelector.get_item_text(0))
	tilesetSelector.select(0)
	for _y in range(mapDims[1]):
		var _row = get_node("MarginContainer/ControlRoot/EditorM/Editor/Control/Container/Panel/ScrollContainer/Rows/{0}".format([_y]))
		for _x in range(mapDims[0]):
			tileGrid["{0},{1}".format(mapDims)] = editorTile.instantiate()
			_row.add_child(tileGrid["{0},{1}".format(mapDims)])
			tileGrid["{0},{1}".format(mapDims)].setTile(EditorManager.activeTileset)

func _on_option_button_item_selected(index):
	EditorManager.activeTileset = InitData.getTileset(tilesetSelector.get_item_text(index))
	print(EditorManager.activeTileset)
