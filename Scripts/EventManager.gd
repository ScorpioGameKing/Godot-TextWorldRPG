extends Node

# Take in an array of command tokens and validate it
func parseCommand(commandTokens:Array):
	var _valid = false
	var _error = ""
	# Is it even a command
	if commandTokens[0][1][0]["type"] == "CMD":
		# Do we have the right number of args
		# TODO: Check for a range of possible args
		if commandTokens[0][1][0]["args"] == commandTokens.size() - 1:
			# At this point a command could be valid
			_valid = true
			# Iterate through possible args
			for _i in range(1, commandTokens.size()):
				# True if the arg is the expected command type false if not
				# TODO: Support multiple arg types to check against
				if commandTokens[_i][1][0]["type"] == commandTokens[0][1][0]["args_types"]:
					_valid = true
				else:
					# Return Arg Type Mismatch Error
					_valid = false
					_error = "Expected {0} Recived {1}".format([commandTokens[0][1][0]["args_types"], commandTokens[_i][1][0]["type"]])
		else: 
			# Return Arg Count Error
			_valid = false
			_error = "Expected {0} args Recived {1} args".format([commandTokens[0][1][0]["args"], commandTokens.size() - 1])
	else: 
		# Return Invalid Command/Token Error
		_valid = false
		_error = "{0} is not a valid command".format([commandTokens[0][0]])
	# Either excecute the function or return the error
	if _valid:
		findAndExecuteCommand(commandTokens)
		return _valid
	else:
		return _error

# MUST recive a fully validated command token array
func findAndExecuteCommand(commandTokens:Array):
	# Match the command to the appropriate function and pass it's values
	# TODO: Reference against existing Command List loaded by InitData
	match commandTokens[0][0].to_lower():
		# Player Movement
		"move":
			match commandTokens[1][0].to_lower():
				# Vertical
				"north", "south":
					WorldManager.plI.moveV(commandTokens[1][1][0]["value"])
				# Horizontal
				"east", "west":
					WorldManager.plI.moveH(commandTokens[1][1][0]["value"])
