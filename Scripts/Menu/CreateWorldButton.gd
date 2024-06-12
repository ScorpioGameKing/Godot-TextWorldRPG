extends Button



func _on_button_up():
	var worldID = "default_world"
	if $"../RowContainer/NameRow/LineEdit".text != "":
		worldID = $"../RowContainer/NameRow/LineEdit".text
	print(worldID)
	var _seed = $"../RowContainer/SeedRow/LineEdit".text
	if _seed == "": _seed = 1
	WorldManager.createNewWorld(WorldManager.worldDimensions, WorldManager.worldMapsPath, worldID, int(_seed), $"../ProgressBars/ProgressBar", $"../ProgressBars/CreationMsg")
	WorldManager.loadWorldMap(WorldManager.worldMapsPath, worldID)
	WorldManager.frameUpdate = true
	EventManager.commandsRecived = []
	get_tree().change_scene_to_file("res://Scenes/Game/Console/console_window.tscn")
	
