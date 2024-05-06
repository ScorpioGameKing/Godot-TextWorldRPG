extends RichTextLabel

# Frames are the actively unpacked and edited map String, eventually this will be
# pulled from the InitData
var savedFrame = "f16g21d04s07~23f13g11T02g09d03s08~21s04f13g11T02g11d04s04~20s06f11g13p01P01g10d03s05~19s03d05f08p18g08d04s04~20s03d06f08p18g09d04s03~21s03d03g02f10g08p02g13d03s05~20s04d03g03f09g09p02g11d04s04~20s04d04g04f07g11p02g12d03s03~21s02d04g05f01f05g13p02g11d02s03~22s04d02g05f02f04g04p12g10d03s02~24s03d03g01B01g01f03f02g06p12g09d03s03~26s02d03g02f03f01g07p02g18d02s02~30s02d03g03f01g08p02g16d03s02~31s03d03g03g08p02g15d03s03~33s02d03g02g08p02g13d03s03~35s03d03g01p10g12d05s03~35s04d02p10g14d04s02~37s03d01g08p11T02g02d04s04~37s03g08p11T02g04d03s03~38s02g24d03s02~42"
var loadedFrame
var testSaveFrame

# Blank Buffer Frame, Starts blank because could want more complex BG manips/draws
var bufferFrame = ""

# Current map's position x,y on the buffer frame and it's dimensions, should never
# exceed the buffer's length, not handled but eventually will be stripped as needed
var mapDims = [71, 21]
var mapPos = [0, 0]

# Everything here runs when done with init
func _ready():
	bufferFrame = createBuffer("x")
	# Testing functions, will be just inital map load calls
	loadedFrame = loadCharString(savedFrame)
	upadateFrame(bufferFrame, loadedFrame, mapDims, mapPos)
	testSaveFrame = saveToCharString(loadedFrame)
	loadedFrame = loadCharString(testSaveFrame)
	upadateFrame(bufferFrame, loadedFrame, mapDims, mapPos)

# Updates the current map display to match any changes, handles BBCode insertion if 
# the Tile is in the current biome set
func upadateFrame(_buffer:String, _mapFrame:String, _mapDims:Array, _mapPos:Array):
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
		
		# Iterate over the chars in the final version of _row 
		for _char in _row:
			# Check if the current character has tile data relevant to drawing
			var _tileData = InitData.findTileData("debug", _char)[0]
			if typeof(_tileData) == TYPE_BOOL:
				# Just add it if _tileData[0] returns false
				_colorRow += _char
			else:
				# Add the relavant BBCodes, currently just color, eventually BG
				# Outlines, animations will be situationally added
				_colorRow += "[color=" + _tileData["tile_color"] + "]" + _char + "[/color]"
		# If we haven't finished append \n to the row, append to _renderFrame, inc the counter
		if _y < InitData.worldBufferDims[1]:
			_renderFrame += _colorRow + "\n"
		else:
			_renderFrame += _colorRow
		_bufferIndex += 1
	# Output
	self.text = _renderFrame
	
# Loads a packed character string
func loadCharString(_charString):
	print("Loaded Map String")
	var _tiles = []
	var _tile = ""
	var _slice_index = 0
	var _tile_index = 0
	var _unpackedString = ""
	# Start builing tiles, c00 styled blocks
	for _char in _charString:
		_tile += _char
		_slice_index += 1
		# Due to map size we know index 3 is the start of a new tile
		if _slice_index == 3:
			# Add the tile to the list
			_tiles.append(_tile)
			_tile = ""
			_slice_index = 0
			_tile_index += 1
	
	# Go through the tiles we pulled from the string
	for _t in _tiles:
		# Pull the Character and Count out
		var _char = _t[0]
		var _count = str(_t[1]) + str(_t[2])
		# Add the character for it's count
		for _i in range(int(_count)):
			_unpackedString += _char
	# return the loaded map
	return(_unpackedString)
	
# Takes the active map and packs it down 
func saveToCharString(_unpackedString):
	print("Saved Map String")
	var _charString = ""
	# Start grabbing row by row
	for _y in range(InitData.worldBufferDims[1]):
		var _rowString = _unpackedString.substr(
			_y * InitData.worldBufferDims[0], InitData.worldBufferDims[0])
		var _trackingChar = ""
		var _seqCount = 0 
		# Run over the row length + 1 cause it fails otherwise IDK
		for _i in range(_rowString.length() + 1):
			# If it's the end of the row we begin to pack the tracking char
			if _i == _rowString.length():
				# Never pack a 00, check if it's under 10 to add a leading 0
				if _seqCount > 0 and _seqCount < 10:
					_charString += _trackingChar + "0" + str(_seqCount)
				else:
					_charString += _trackingChar + str(_seqCount)
			# If we aren't tracking a character set it and count it
			elif _trackingChar == "":
				_trackingChar = _rowString[_i]
				_seqCount += 1
			# Tracking? Count it
			elif _rowString[_i] == _trackingChar:
				_seqCount += 1
			# If the tracked and current don't match then pack
			elif _rowString[_i] != _trackingChar:
				if _seqCount > 0 and _seqCount < 10:
					# Never pack a 00, check if it's under 10 to add a leading 0
					_charString += _trackingChar + "0" + str(_seqCount)
				else:
					_charString += _trackingChar + str(_seqCount)
				# Set the new char and count it
				_trackingChar = _rowString[_i]
				_seqCount = 1
	# Return the packed string
	return(_charString)
	
# Fills an empty buffer with a character
func createBuffer(_bufferChar:String) -> String:
	var _buffer = ""
	for _char in range(InitData.worldBufferDims[0] * InitData.worldBufferDims[1]):
		_buffer += _bufferChar
	return _buffer
