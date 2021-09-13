extends Node

func _ready():
	var hometown_scene = preload("res://Scenes/Places/Hometown.tscn").instance()
	hometown_scene.set_name("Hometown")
	self.add_child(hometown_scene)
	var player_scene = preload("res://Entities/Player/Player.tscn").instance()
	player_scene.set_name("Player")
	self.add_child(player_scene)

