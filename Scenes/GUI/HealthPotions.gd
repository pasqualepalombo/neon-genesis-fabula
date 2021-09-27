extends ColorRect


func _ready():
	if(get_parent().get_parent().get_node("Player").connect("player_stats_changed", self, "on_player_stats_changed") != 0):
		print("Signal Connection Error: PLAYER->GUI(HealthPotions) player_stats_changed")
	self.visible = true


func on_player_stats_changed(player):
	$Label.text = str(player.health_potions)

