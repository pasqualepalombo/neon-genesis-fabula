# this file is attached to Game.tscn as script
extends Node

var load_saved_game = false

func _ready():
	if Settings.enable_audio:
		$Music.playing = true
	
	var file = File.new()
	if load_saved_game and file.file_exists("user://savegame.json"):
		file.open("user://savegame.json", File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		
		$Player.from_dictionary(data.player)
		$MotherHouse/Mother.from_dictionary(data.mother)
		$DoctorHouse/Doctor.from_dictionary(data.doctor)
		$Merchant.from_dictionary(data.merchant)
		$Warehouse/SHDealer.from_dictionary(data.shdealer)
		ItemHandler.temporary_items = data.inventory


func save():
	var data = {
		"player" : $Player.to_dictionary(),
		"mother" : $MotherHouse/Mother.to_dictionary(),
		"doctor" : $DoctorHouse/Doctor.to_dictionary(),
		"merchant" : $Merchant.to_dictionary(),
		"shdealer" : $Warehouse/SHDealer.to_dictionary(),
		"inventory" : ItemHandler.temporary_items
	}
	
	var file = File.new()
	file.open("user://savegame.json", File.WRITE)
	var json = to_json(data)
	file.store_line(json)
	file.close()
