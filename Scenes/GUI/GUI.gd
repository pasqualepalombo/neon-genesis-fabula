extends CanvasLayer


func _ready():
	pass
	if(get_parent().get_node("Player").connect("player_sleep", self, "on_player_sleep") != 0):
		print("Signal Connection Error: PLAYER->GUI(Health) player_stats_changed")
	$Messagetoplayers.show()
	$Messagetoplayers.popup_centered()


func on_player_sleep(player):
	$AnimationPlayer.play("Sleep")
	 
	
func _input(event):
	if $Messagetoplayers.visible:
		if event is InputEventKey:
			$Messagetoplayers.hide()
