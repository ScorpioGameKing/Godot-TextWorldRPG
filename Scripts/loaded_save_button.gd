extends Control

var loadedWorldPath
var loadedWorldID

func constructor(path, id):
	$Button.text = id
	loadedWorldPath = path
	loadedWorldID = id

func _on_button_button_up():
	WorldManager.loadWorldMap(loadedWorldPath, loadedWorldID)
	get_tree().change_scene_to_file("res://Scenes/console_window.tscn")
