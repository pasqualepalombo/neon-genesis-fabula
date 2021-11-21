extends CanvasLayer


func _ready():
	if(get_parent().get_node("Player").connect("player_sleep", self, "on_player_sleep") != 0):
		print("Signal Connection Error: PLAYER->GUI(Health) player_stats_changed")


func on_player_sleep(_player):
	$AnimationPlayer.play("Sleep")
