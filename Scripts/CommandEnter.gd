extends RichTextLabel

@onready var commandsRecived = []
@onready var testString = "12:34) Player printed a Test Message"

func _ready():
	clearConsole()
	

func clearConsole():
	self.text = ""

func updateConsole():
	clearConsole()
	for _cmd in commandsRecived:
		print(_cmd)
		var _coloredText = colorTime(_cmd[0])
		print(_coloredText)
		self.text += _coloredText + "\n"
		print(self.text)

func _on_command_enter_text_submitted(new_text):
	var _curTime = [InitData.worldHour, InitData.worldMin]
	if commandsRecived.size() == 100:
		commandsRecived.pop_front()
	commandsRecived.append([str(_curTime[0]) + ":" + str(_curTime[1])+ ") " + new_text])
	updateConsole()
	
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
