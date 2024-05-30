extends Control

var currentMenu

func _ready():
	currentMenu = $FrontMenus/MainMenu
	setMenu("MAIN")

func setMenu(newMenu:String):
	match newMenu:
		"MAIN":
			print("Main Menu")
			currentMenu.visible = false
			currentMenu = $FrontMenus/MainMenu
			currentMenu.visible = true
		"NEW":
			print("New Game Menu")
			currentMenu.visible = false
			currentMenu = $FrontMenus/NewGameMenu
			currentMenu.visible = true
		"LOAD":
			print("Load Game Menu")
			currentMenu.visible = false
			currentMenu = $FrontMenus/LoadMenu
			currentMenu.visible = true
		"DELETE":
			print("Deletion Menu")
			currentMenu.visible = false
			currentMenu = $FrontMenus/MainMenu
			currentMenu.visible = true
		"OPTIONS":
			print("Options Menu")
			currentMenu.visible = false
			currentMenu = $FrontMenus/MainMenu
			currentMenu.visible = true

func _on_back_button_button_up():
	setMenu("MAIN")

func _on_new_game_button_button_up():
	setMenu("NEW")

func _on_load_game_button_button_up():
	setMenu("LOAD")

