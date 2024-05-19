extends RichTextLabel

@onready var commandsRecived = []
@onready var testString = "12:34) Move North"

func _ready():
	clearConsole()

func clearConsole():
	self.text = ""

func updateConsole():
	clearConsole()
	for _cmd in commandsRecived:
		var _coloredText = colorTime(_cmd[0])
		self.text += _coloredText + "\n"

# When the Enter Key is pressed send command to event manager and print results
func _on_command_enter_text_submitted(new_text):
	# Eventually get time from WorldManager
	var _curTime = [InitData.worldHour, InitData.worldMin]
	# Parse out words and tokenize the command
	InitData.RX.compile(InitData.RXExpressions[4])
	var _textTokens = InitData.RX.search_all(new_text)
	var _command = []
	var _errorQueue = []
	for _textToken in _textTokens:
		var _typeToken = InitData.getToken(_textToken.get_string())
		if typeof(_typeToken) == TYPE_ARRAY:
			# Append valid token
			_command.append(_typeToken)
		else:
			# Append error token
			_command.append(["{0}".format([_textToken.get_string()]), [{ "type": "UKN_WRD" }]])
	var _validCommand = EventManager.parseCommand(_command)
	# Error Check
	if typeof(_validCommand) == TYPE_STRING:
		_errorQueue.append(_validCommand)
	else:
		# Resize command history to fit latest command
		if commandsRecived.size() == 100:
			commandsRecived.pop_front()
		commandsRecived.append([str(_curTime[0]) + ":" + str(_curTime[1])+ ") " + new_text])
	# Append errors to the history
	for _i in range(_errorQueue.size()):
		print(_errorQueue[_i])
		commandsRecived.append([str(_curTime[0]) + ":" + str(_curTime[1])+ ") " + _errorQueue[_i]])
	# Display results
	updateConsole()
	WorldManager.frameUpdate = true
	
# All displayed outputs include world time as hh:mm), this colors it
func colorTime(timeText:String):
	var _colorText = ""
	var _token = timeText.substr(0, 6)
	var _color = "E77828"
	for _char in _token:
		if _char == ":" or _char == ")":
			_colorText += "[color=ffffff]" + _char + "[/color]"
			_color = "E77828"
		else:
			_colorText += "[color=" + _color + "]" + _char + "[/color]"
	return _colorText + timeText.substr(6, timeText.length())
