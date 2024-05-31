extends Control

@onready var sheetLabel = $Columns/ActiveSheet/Panel/SheetLabel
@onready var sheetText = $Columns/ActiveSheet/SheetBG/SheetInfo

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
		else: 
			baseCurPair = "{0}".format([playerStats[stat][0]])
		print("{0}: {1}".format([stat, baseCurPair]))
		sheetText.text += "{0}: {1} \n\n".format([stat, baseCurPair])
	

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
	pass
	
func settingSheet():
	pass


func _on_player_button_button_up():
	playerSheet()
