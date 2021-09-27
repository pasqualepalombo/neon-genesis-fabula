extends ColorRect


func _ready():
	if(get_parent().get_parent().get_node("Player").connect("player_stats_changed", self, "on_player_stats_changed") != 0):
		print("Signal Connection Error: PLAYER->GUI(QuestObjects) player_stats_changed")
	#TODO check on ready if player own the medicine (or the generic object)
	self.visible = false


func on_player_stats_changed(player):
	#TODO check if player has object -> show, else hide
	pass

