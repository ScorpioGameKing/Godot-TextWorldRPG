extends Control

var loadedWorldPath
var loadedWorldID

func constructor(path, id):
	$Button.text = id
	loadedWorldPath = path
	loadedWorldID = id

func _on_button_button_up():
	WorldManager.deleteWorldMap(loadedWorldPath, loadedWorldID)
	
