extends Node

var inEditor = false
var activeTileset
var activeBrush = ["terrain", "x"]

func setBrush(_type, _symbol):
	activeBrush = [_type, _symbol]
	print(activeBrush)
