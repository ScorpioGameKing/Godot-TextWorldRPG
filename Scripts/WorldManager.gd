extends Node
# TODO: Entity Loading System, Entity AI

# Update Flags
var frameUpdate = true

# HACK: Load Entities for testing
var plS = load("res://Scenes/player.tscn")
var plI = plS.instantiate()
var entitiesLive = [] 

# HACK: Place a player for testing functions
func _ready():
	add_child(plI)

# TODO: Implement finalized TESTGEN gen here
func generateWorldMap():
	pass
