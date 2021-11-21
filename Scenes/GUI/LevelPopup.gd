extends Popup

var player

func _ready():
	if(get_parent().get_parent().get_node("Player").connect("player_level_up", self, "player_level_up") != 0):
		print("Signal Connection Error: PLAYER->GUI(LevelPopoup) player_level_up")
	player = get_tree().root.get_node("Game/Player")
	set_process_input(false)
	$ColorRect/Label2.text = Settings.yesKey
	$ColorRect/Label3.text = Settings.nokey


func player_level_up():
	set_process_input(true)
	popup_centered()
	get_tree().paused = true


func _input(event):
	if event is InputEventKey:
		if event.is_action_pressed("ui_accept"):
			player.health_max += 50
			player.health += 50
			player.emit_signal("player_stats_changed", player)
			hide()
			set_process_input(false)
			get_tree().paused = false
		elif event.is_action_pressed("ui_cancel"):
			#TODO
			#player.mana_max += 50
			#player.mana += 50
			#player.emit_signal("player_stats_changed", player)
			#hide()
			#set_process_input(false)
			#get_tree().paused = false
