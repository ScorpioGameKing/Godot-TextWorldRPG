extends AudioStreamPlayer

var bgmPath = "res://Sounds/Music/battle_one.wav"

# Called when the node enters the scene tree for the first time.
func _ready():
	play()
	
func _process(_delta):
	if !playing:
		play()
#TODO: Swap Around BGM Music, SFX, Ambiance
