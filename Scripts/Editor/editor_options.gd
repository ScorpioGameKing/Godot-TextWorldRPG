extends PanelContainer

@onready var tName = $Rows/Name/TileName
@onready var tSymbol = $Rows/Symbol/TileSymbol
@onready var tColor = $Rows/Color/TileColor
@onready var tFlags = $Rows/Flags
var flags = []

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if EditorManager.updateTileInfo:
		updateTileInfo()
		EditorManager.updateTileInfo = false

func updateTileInfo():
	for _flag in flags:
		_flag.queue_free()
	flags = []
	tName.text = EditorManager.editorTileName
	tSymbol.text = EditorManager.editorTileSymbol
	tColor.text = EditorManager.editorTileColor
	for _flag in EditorManager.editorOptionsTileFlags:
		var flagLabel = Label.new()
		flagLabel.text = "{0}: {1}".format([_flag, EditorManager.editorOptionsTileFlags[_flag]])
		tFlags.add_child(flagLabel)
		flags.append(flagLabel)
