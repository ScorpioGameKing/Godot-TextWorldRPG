extends RichTextLabel

# Clear on load just in case, may have to change
func _ready():
	clearConsole()

# Tells the Console to update itself
func _process(_delta):
	if EventManager.updateConsoleLog:
		updateConsole()

# Clears the console
func clearConsole():
	self.text = ""

# Clear then update the console with the command log
func updateConsole():
	clearConsole()
	for _cmd in EventManager.commandsRecived:
		var _coloredText = colorTime(_cmd[0])
		self.text += _coloredText + "\n"
	EventManager.updateConsoleLog = false

# When the Enter Key is pressed send command to event manager and print results
func _on_command_enter_text_submitted(new_text:String):
	# TODO: Eventually get time from WorldManager
	var _curTime = [WorldManager.worldDate["hour"], WorldManager.worldDate["minute"]]
	# Parse out words and tokenize the command
	InitData.RX.compile(InitData.RXExpressions[4])
	var _textTokens = InitData.RX.search_all(new_text)
	var _command = []
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
		EventManager.errorQueue.append(_validCommand)
	else:
		EventManager.trimLog()
		EventManager.commandsRecived.append([str(_curTime[0]) + ":" + str(_curTime[1])+ ") " + new_text])
	# Append errors to the history
	for _i in range(EventManager.errorQueue.size()):
		#print(EventManager.errorQueue[_i])
		EventManager.commandsRecived.append([str(_curTime[0]) + ":" + str(_curTime[1])+ ") " + EventManager.errorQueue[_i]])
		EventManager.errorQueue.pop_front()
	# Display results
	EventManager.updateConsoleLog = true
	
# All displayed outputs include world time as hh:mm), this colors it
func colorTime(timeText:String) -> String:
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
