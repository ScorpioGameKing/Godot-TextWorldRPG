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
		"EDITOR":
			print("Map Editor")
			EditorManager.loadEditor()
		"OPTIONS":
			print("Options Menu")
			currentMenu.visible = false
			currentMenu = $FrontMenus/MainMenu
			currentMenu.visible = true
		"EXIT":
			print("Exiting")
			get_tree().quit()

func _on_back_button_button_up():
	setMenu("MAIN")

func _on_new_game_button_button_up():
	setMenu("NEW")

func _on_load_game_button_button_up():
	setMenu("LOAD")
	
func _on_map_builder_button_up():
	setMenu("EDITOR")

func _on_exit_button_button_up():
	setMenu("EXIT")



