extends Node

# Player Name , Symbol, Color
var playerName
var playerSymbol
var playerColor

# Player Postion
var pos = ["00","00"]

# Player Stats
var hp = 50
var mp = 50
var strength = 5
var agility = 5
var inteligence = 5
var charisma = 5
var luck = 5

# Create a new player
func createNewPlayer(newName:String, newColor:String):
	playerName = newName
	playerSymbol = playerName.substr(0,1)
	playerColor = newColor

# Get and set position
func getPosition():
	return [playerSymbol, pos]

func setPosition(newPos:Array):
	pos = newPos

func moveV(val:int):
	print("Vertical Move")
	print("{0}".format([int(pos[1]) + val]))
	if int(pos[1]) + val < 10:
		pos[1] = "0{0}".format([int(pos[1]) + val])
	else:
		pos[1] = "{0}".format([int(pos[1]) + val])

func moveH(val:int):
	print("Horizontal Move")
	print("{0}".format([int(pos[0]) + val]))
	if int(pos[0]) + val < 10:
		pos[0] = "0{0}".format([int(pos[0]) + val])
	else:
		pos[0] = "{0}".format([int(pos[0]) + val])
