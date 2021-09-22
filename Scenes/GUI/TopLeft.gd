extends ColorRect


func _ready():
	if(get_parent().get_parent().get_node("Player").connect("player_stats_changed", self, "on_player_stats_changed") != 0):
		print("Signal Connection Error: PLAYER->GUI(TopLeft) player_stats_changed")
	self.visible = true


func on_player_stats_changed(player):
	$Coins.bbcode_text = "Coins: " + str(player.coins)
	$Reputation.bbcode_text = "Reputation: " + str(player.reputation)
