extends Node

func parseCommand(commandTokens:Array):
	var _valid = false
	var _error = ""
	if commandTokens[0][1][0]["type"] == "CMD":
		if commandTokens[0][1][0]["args"] == commandTokens.size() - 1:
			_valid = true
			for _i in range(1, commandTokens.size()):
				if commandTokens[_i][1][0]["type"] == commandTokens[0][1][0]["args_types"]:
					_valid = true
				else:
					_valid = false
					_error = "Expected {0} Recived {1}".format([commandTokens[0][1][0]["args_types"], commandTokens[_i][1][0]["type"]])
		else: 
			_valid = false
			_error = "Expected {0} args Recived {1} args".format([commandTokens[0][1][0]["args"], commandTokens.size() - 1])
	else: 
		_valid = false
		_error = "{0} is not a valid command".format([commandTokens[0][0]])
	if _valid:
		findAndExecuteCommand(commandTokens)
		return _valid
	else:
		return _error
	
func findAndExecuteCommand(commandTokens:Array):
	match commandTokens[0][0].to_lower():
		"move":
			match commandTokens[1][0].to_lower():
				"north", "south":
					WorldManager.plI.moveV(commandTokens[1][1][0]["value"])
				"east", "west":
					WorldManager.plI.moveH(commandTokens[1][1][0]["value"])
