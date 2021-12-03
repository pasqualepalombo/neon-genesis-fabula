extends CanvasLayer

func _ready():
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
	if $Thankstoplayers.visible:
		print("0")
		if event is InputEventKey:
			$Thankstoplayers.hide()
			print("1")


func showthanks():
		$Thankstoplayers.show()
		$Thankstoplayers.popup_centered()
