extends Node

# Update Flags
var frameUpdate = true

# Loaded Entities
var plS = load("res://Scenes/player.tscn")
var plI = plS.instantiate()
var entitiesLive = [] 

func _ready():
	add_child(plI)
