extends MarginContainer

var tileSymbol = "x"
var colorSymbol = ""
var tileType = "terrain"
var tileset
var tileData
@onready var tileLabel = $Button/Label

func setTile(_ts, _type = tileType, _symbol = tileSymbol):
	if _type != tileType: tileType = _type
	if _symbol != tileType: tileSymbol = _symbol
	tileData = InitData.getTileData(_ts, _type, _symbol)
	if tileData:
		colorSymbol = "[color={0}]{1}[/color]".format([tileData["tile_color"], _symbol])
	else: 
		colorSymbol = _symbol 
	tileLabel.text = colorSymbol

func updateTile(_ts, _type, _symbol):
	tileData = InitData.getTileData(_ts, _type, _symbol)
	if tileData:
		colorSymbol = "[color={0}]{1}[/color]".format([tileData["tile_color"], _symbol])
	else: 
		colorSymbol = _symbol 
	tileLabel.text = colorSymbol

func _on_button_gui_input(event):
	if event is InputEventMouseButton and event.pressed:
		match event.button_index:
			MOUSE_BUTTON_LEFT:
				# left button clicked
				print("Left will edit")
				updateTile(EditorManager.activeTileset, EditorManager.activeBrush[0], EditorManager.activeBrush[1])
			MOUSE_BUTTON_RIGHT:
				# right button clicked
				print("Right gets info")
