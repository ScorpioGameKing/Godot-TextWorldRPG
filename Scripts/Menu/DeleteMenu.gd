extends Control

var savedMapButton = preload("res://Scenes/Menu/delete_save_button.tscn")
var savedMaps:Dictionary

func indexSaves():
	var dir = DirAccess.open(WorldManager.worldMapsPath)
	if dir:
		dir.list_dir_begin()
		var file_name = dir.get_next()
		while file_name != "":
			if dir.current_is_dir():
				print("Found directory: " + file_name)
			else:
				print("Found file: " + file_name)
				if !savedMaps.has(file_name):
					print("Indexed Save")
					savedMaps[file_name] = savedMapButton.instantiate()
					get_node("ScrollContainer/VBoxContainer").add_child(savedMaps[file_name])
					savedMaps[file_name].constructor(WorldManager.worldMapsPath, file_name)
			file_name = dir.get_next()
	else:
		print("An error occurred when trying to access the path.")


func _on_visibility_changed():
	if visible:
		indexSaves()
	else:
		for mapButton in savedMaps:
			savedMaps[mapButton].queue_free()
		savedMaps.clear()
