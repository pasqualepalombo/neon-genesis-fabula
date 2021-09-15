extends ColorRect


func _ready():
	if(get_parent().get_parent().get_node("Player").connect("player_stats_changed", self, "on_player_stats_changed") != 0):
		print("Signal Connection Error: PLAYER->GUI player_stats_changed")


func on_player_stats_changed(player):
	$Bar.rect_size.x = 72 * player.health / player.health_max

