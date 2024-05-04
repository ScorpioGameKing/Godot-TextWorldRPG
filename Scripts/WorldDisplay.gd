extends TextEdit

var savedFrame = "f09g18d02s01~05f10g15d03s03~04f11g06T03g06d03s02~04f12g05T03g06d02s02~05f10g07p02g08d02s02~04f10g07p02g08d04s01~03f09g08p02g09d02s02~03f08p10P01g08d04s01~03f08p11g09d02s01~04f09g08p02g10d02s01~03f07g10p02g11d02s01~02f06g11p02g11d02s01~02f04g13p09T03g02d01s01~02f02g15p09T03g01d02s01~02f01g10B01g05p02g11d01s02~02g17p02g12d01s02~01g17p02g13d01s01~01g17p08g07d01s02g17p08g07d03g23p02g08d02g23p02g10g23p02g10"
var loadedFrame
var testSaveFrame
static var worldDims = [35, 22]

func _ready():
	loadedFrame = loadCharString(savedFrame)
	#print(loadedFrame)
	upadateFrame(loadedFrame)
	testSaveFrame = saveToCharString(loadedFrame)
	loadedFrame = loadCharString(testSaveFrame)
	upadateFrame(loadedFrame)

func upadateFrame(newFrame):
	print("Upadated Frame")
	var _renderFrame = ""
	for _y in range(worldDims[1]):
		# print("Row: " + str(_y))
		var _row = ""
		for _x in range(worldDims[0]):
			# print("Col: " + str(_x))
			# print(str(newFrame[_x + (worldDims[0] * _y)]))
			_row += str(newFrame[_x + (worldDims[0] * _y)])
			#print(str(newFrame[_x + (worldDims[0] * _y) - 1]) + str(newFrame[_x + (worldDims[0] * _y)]))
			if _x != worldDims[0] - 1:
				_row += " "
		if _y != worldDims[1] - 1:
			_row += "\n"
		# print(_row)
		_renderFrame += _row
	self.text = _renderFrame
	
func loadCharString(_charString):
	print("Loaded Map String")
	var _tiles = []
	var _tile = ""
	var _slice_index = 0
	var _tile_index = 0
	var _unpackedString = ""
	for _char in _charString:
		_tile += _char
		_slice_index += 1
		if _slice_index == 3:
			_tiles.append(_tile)
			_tile = ""
			_slice_index = 0
			_tile_index += 1
	for _t in _tiles:
		var _char = _t[0]
		var _count = str(_t[1]) + str(_t[2])
		#print("Char: " + _char + " Count: " + str(int(_count)) + " Tile: " + _t)
		for _i in range(int(_count)):
			_unpackedString += _char
	#print(_tiles)
	# print(_unpackedString)
	return(_unpackedString)
	
func saveToCharString(_unpackedString):
	print("Saved Map String")
	var _charString = ""
	for _y in range(worldDims[1]):
		var _rowString = _unpackedString.substr(_y * worldDims[0], worldDims[0])
		var _trackingChar = ""
		var _seqCount = 0
		for _i in range(_rowString.length() + 1):
			if _i == _rowString.length():
				if _seqCount > 0 and _seqCount < 10:
					_charString += _trackingChar + "0" + str(_seqCount)
				else:
					_charString += _trackingChar + str(_seqCount)
			elif _trackingChar == "":
				_trackingChar = _rowString[_i]
				_seqCount += 1
			elif _rowString[_i] == _trackingChar:
				_seqCount += 1
			elif _rowString[_i] != _trackingChar:
				if _seqCount > 0 and _seqCount < 10:
					_charString += _trackingChar + "0" + str(_seqCount)
				else:
					_charString += _trackingChar + str(_seqCount)
				_trackingChar = _rowString[_i]
				_seqCount = 1
	return(_charString)
