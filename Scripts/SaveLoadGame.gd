extends Node

var load_saved_game = false

func _ready():
	var file = File.new()
	if load_saved_game and file.file_exists("user://savegame.json"):
		file.open("user://savegame.json", File.READ)
		var data = parse_json(file.get_as_text())
		file.close()
		
		$Player.from_dictionary(data.player)
		$Fiona.from_dictionary(data.fiona)
		if($Fiona.necklace_found):
			$Necklace.queue_free()


func save():
	var data = {
		"player" : $Player.to_dictionary(),
		"fiona" : $Fiona.to_dictionary(),
	}
	
	var file = File.new()
	file.open("user://savegame.json", File.WRITE)
	var json = to_json(data)
	file.store_line(json)
	file.close()
