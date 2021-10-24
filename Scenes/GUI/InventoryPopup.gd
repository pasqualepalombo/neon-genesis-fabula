extends Popup

onready var player = get_tree().root.get_node("Game/Player")
var already_paused
var selected_menu := Vector2(0,0)

func change_menu_color():
	pass


func load_all_stats():
	$General/Coins.bbcode_text = "Coins: " + str(player.coins)
	$General/Reputation.bbcode_text = "Reputation: " + str(player.reputation)
	$General/Level.bbcode_text = "Level: " + str(player.level)
	$General/Experience.bbcode_text = "Experience: " + str(player.experience) + "/" + str(player.xp_next_level)


func _input(_event):
	if not visible:
		if Input.is_action_just_pressed("inventory"):
			# Pause game
			get_tree().paused = true
			# Reset the popup
			selected_menu.x = 0
			selected_menu.y = 0
			change_menu_color()
			# Show popup
			player.set_process_input(false)
			popup()
			load_all_stats()
	else:
		if Input.is_action_just_pressed("inventory"):
			# Resume game
			get_tree().paused = false
			player.set_process_input(true)
			hide()
