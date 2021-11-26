extends Node

var yesKey
var nokey
var enable_audio = true

func _ready():
	# If the game run on PC with keyboard
	yesKey = "[E]"
	nokey = "[Shift]"
	enable_audio = true
