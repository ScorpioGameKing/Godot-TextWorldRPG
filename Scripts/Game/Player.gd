extends Node

# TODO: Bring over stats from spreadsheet, refine formulas

# Player Name , Symbol, Color
var playerName
var playerSymbol
var playerColor

# Player Postion
var pos = [0,0]
var moveableDirs = [false, false, false, false] # N, S, E, W

# Player Stats
var hpBase = 50
var mpBase = 50
var strengthBase = 5
var agilityBase = 5
var inteligenceBase = 5
var charismaBase = 5
var luckBase = 5

# Player Stats
var hpCurrent = 50
var mpCurrent = 50
var strengthCurrent = 5
var agilityCurrent = 5
var inteligenceCurrent = 5
var charismaCurrent = 5
var luckCurrent = 5

# Create a new player
func createNewPlayer(newName:String, newColor:String):
	playerName = newName
	playerSymbol = playerName.substr(0,1)
	playerColor = newColor

func getStats() -> Dictionary:
	return {
	"name": [playerName, playerSymbol],
	"hp": [hpBase, hpCurrent], 
	"mp": [mpBase, mpCurrent], 
	"strength": [strengthBase, strengthCurrent], 
	"agility": [agilityBase, agilityCurrent], 
	"inteligence": [inteligenceBase, inteligenceCurrent], 
	"charisma": [charismaBase, charismaCurrent],
	 "luck": [luckBase, luckCurrent]
	}

# Get and set position
func getPosition() -> Array:
	return [playerSymbol, pos]

func setPosition(newPos:Array):
	pos = newPos

# Set Collisions
func setMoveable(collisions:Array):
	moveableDirs = collisions

func moveV(val:int):
	print("Vertical Move")
	# If val 0 check north
	if val < 0:
		# Wrap map if pos less than 0
		if pos[1] + val < 0:
			WorldManager.moveV(val)
			pos[1] = WorldManager.screenDimensions[1] - 1
		# move if possible
		elif moveableDirs[0]:
			pos[1] = pos[1] + val
	# pos check south
	elif val > 0:
		# wrap map if pos off the bottom
		if pos[1] + val >= WorldManager.screenDimensions[1]:
			WorldManager.moveV(val)
			pos[1] = 0
		# move if possible
		elif moveableDirs[1]:
			pos[1] = pos[1] + val

func moveH(val:int):
	print("Horizontal Move")
	# if negative value check west
	if val < 0:
		# Wrap map if pos less than 0
		if pos[0] + val < 0:
			WorldManager.moveH(val)
			pos[0] = WorldManager.screenDimensions[0] - 1
		# move if possible
		elif moveableDirs[2]:
			pos[0] = pos[0] + val
	# if positive value check east
	elif val > 0:
		# Wrap map if off map
		if pos[0] + val >= WorldManager.screenDimensions[0]:
			WorldManager.moveH(val)
			pos[0] = 0
		# Move if possible
		elif moveableDirs[3]:
			pos[0] = pos[0] + val
