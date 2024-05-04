extends TextEdit

@onready var commandsRecived = []

func _ready():
	clearConsole()

func clearConsole():
	self.text = ""

func updateConsole():
	clearConsole()
	for _cmd in commandsRecived:
		var _timeString = str(_cmd[0][0]) + ":" + str(_cmd[0][1]) + ":" + str(_cmd[0][2])
		self.text += _timeString + " " + _cmd[1] + "\n"
		self.scroll_vertical = get_line_count()

func _on_command_enter_text_submitted(new_text):
	print("Command Entered: " + new_text)
	var _curTime = Time.get_datetime_dict_from_system()
	print("Time: " + str(_curTime["hour"]) + ":" + str(_curTime["minute"]))
	if commandsRecived.size() == 100:
		commandsRecived.pop_front()
	commandsRecived.append([[_curTime["hour"],_curTime["minute"], _curTime["second"]],new_text])
	updateConsole()
	
