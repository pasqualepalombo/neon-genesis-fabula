extends Node

var yesKey
var nokey
var enable_audio = true
var is_in_pause = false
var is_in_inventory = false

func _ready():
	# If the game run on PC with keyboard
	yesKey = "[E]"
	nokey = "[Shift]"
	enable_audio = true
