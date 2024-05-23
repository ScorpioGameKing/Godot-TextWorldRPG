extends RichTextLabel

# Frames are the actively unpacked and edited map String
var savedFrame = InitData.getMap([49, 49], "terrain")
var loadedFrame
var testSaveFrame
# HACK: Grab a test tileset for default render
@onready var mapTS = InitData.getTileset("ts1")

# Blank Buffer Frame, Starts blank because could want more complex BG manips/draws
var bufferFrame = ""

# TODO: Trim Map if offscreen
# Current map's position x,y on the buffer frame and it's dimensions
var mapDims = [71, 21]
var mapPos = [0, 0]

# Everything here runs when done with init
# HACK: Loading everything through here for testing, Move to world manager
func _ready():
	WorldManager.plI.createNewPlayer("Player", "00ff00")
	WorldManager.plI.setPosition(["25","09"])
	WorldManager.entitiesLive.append(WorldManager.plI.getPosition())
	bufferFrame = createBuffer()
	loadedFrame = loadCharString(savedFrame)

# Check if the WorldManager has called for an update
func _process(_delta):
	if WorldManager.frameUpdate:
		updateFrame()
		WorldManager.frameUpdate = false

# Updates the current map display to match any changes, handles BBCode insertion if 
# the Tile is in the current biome set
func updateFrame(_buffer:String = bufferFrame, _mapFrame:String = loadedFrame, _mapDims:Array = mapDims, _mapPos:Array = mapPos):
	print("Upadated Frame")
	var _renderFrame = ""
	var _bufferIndex = 0 # Tracks the current index of buffer's y row
	var _replaceCount = 0 # Tracks the current index of map's y row
	
	# Start counting through the height of the standard map/buffer size
	for _y in range(InitData.worldBufferDims[1]):
		var _row = _buffer.substr(_bufferIndex * InitData.worldBufferDims[0], InitData.worldBufferDims[0])
		var _colorRow = ""
		
		# Has _y reached a row of the map
		if _y in range(_mapPos[1], _mapPos[1] + _mapDims[1]):
			# Split the current row into the buffer tile before, to replace and after
			var _start = _row.substr(0, _mapPos[0])
			var _replace = _row.substr(_mapPos[0], _mapPos[0] + _mapDims[0])
			var _end = _row.substr(_mapPos[0] + _mapDims[0], _row.length())
			# Replace the section with the map's full row
			_replace = _mapFrame.substr(_replaceCount * _mapDims[0], _mapDims[0])
			# Rebuild the string and inc the counter
			_row = _start + _replace + _end
			_replaceCount += 1
			_renderFrame += _row
		_bufferIndex += 1
	# Place Entities
	_renderFrame = placeEntities(_renderFrame, WorldManager.entitiesLive)
	# Color the map
	_renderFrame = colorMap(_renderFrame, mapTS, 0)
	# Output
	self.text = _renderFrame
	
# Color a map String
func colorMap(map:String, tileSet, layer:int):
	var _colorString = ""
	var _count = 0
	InitData.RX.compile(InitData.RXExpressions[1])
	var _rows = InitData.RX.search_all(map)
	for _result in _rows:
		var _colorRow = ""
		for _symbol in _result.get_string():
			var _tileData = InitData.getTileData(tileSet, "terrain", _symbol)
			if typeof(_tileData) == TYPE_BOOL:
				# Not clean but check if entity
				var _entData = InitData.getTileData(tileSet, "entities", _symbol)
				if typeof(_entData) == TYPE_BOOL:
					_colorRow += _symbol
				else:
					_colorRow += "[color=" + _entData["tile_color"] + "]" + _symbol + "[/color]"
			else:
				# Add the relavant BBCodes
				# TODO: Add support for BG, Higlight, Outline, Etc
				_colorRow += "[color=" + _tileData["tile_color"] + "]" + _symbol + "[/color]"
		if _count == _rows.size():
			_colorString += _colorRow
		else:
			_colorString += _colorRow + "\n"
		_count += 1
	return _colorString
	
# Place Entities on a map string
func placeEntities(map:String, entities:Array = []):
	for entPos in entities:
		var _i = int(entPos[1][0]) + (int(entPos[1][1]) * mapDims[0])
		map[_i] = entPos[0]
	return map

# Loads a packed character string
func loadCharString(_charString:String) -> String:
	print("Loaded Map String")
	var _unpackedString = ""
	InitData.RX.compile(InitData.RXExpressions[0])
	for _result in InitData.RX.search_all(_charString):
		var _char = _result.get_string()[0]
		var _count = _result.get_string()[1] + _result.get_string()[2]
		for _i in range(int(_count)):
			_unpackedString += _char
	return(_unpackedString)
	
# Takes the active map and packs it down 
func saveToCharString(_unpackedString:String) -> String:
	print("Saved Map String")
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
	
# Fills an empty buffer with a character
func createBuffer(_bufferChar:String = "x") -> String:
	var _buffer = ""
	for _char in range(InitData.worldBufferDims[0] * InitData.worldBufferDims[1]):
		_buffer += _bufferChar
	return _buffer
