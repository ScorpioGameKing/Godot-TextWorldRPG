extends Control

@onready var sheetLabel = $Columns/ActiveSheet/Panel/SheetLabel
@onready var sheetText = $Columns/ActiveSheet/SheetBG/SheetInfo

func _ready():
	commandSheet()

func playerSheet():
	# Returns [hp, mp, strength, agility, inteligence, charisma, luck]
	var playerStats = WorldManager.plI.getStats()
	sheetLabel.text = "Player Sheet"
	sheetText.text = ""
	print(playerStats)
	for stat in playerStats:
		var baseCurPair = ""
		if stat == "hp" or stat == "mp":
			baseCurPair = "{0}:{1}".format([playerStats[stat][0], playerStats[stat][1]])
		elif int(playerStats[stat][0]) != int(playerStats[stat][1]): 
			baseCurPair = "{0}".format([playerStats[stat][1]])
		else:
			baseCurPair = "{0}".format([playerStats[stat][0]])
		print("{0}: {1}".format([stat, baseCurPair]))
		sheetText.text += "{0}: {1} \n\n".format([str(stat).to_upper(), baseCurPair])
	

func skillSheet():
	pass

func inventorySheet():
	pass
	
func questSheet():
	pass
	
func journalSheet():
	pass
	
func macroSheet():
	pass
	
func commandSheet():
	sheetLabel.text = "Command Sheet"
	sheetText.text = ""
	for _token in InitData.CMD_DICT.values()[0]:
		sheetText.text += _token["data"][0]["description"]
	
	
func settingSheet():
	pass


func _on_player_button_button_up():
	playerSheet()


func _on_help_button_button_up():
	commandSheet()
