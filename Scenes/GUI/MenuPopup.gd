extends Popup

onready var player = get_tree().root.get_node("Game/Player")
var already_paused
var selected_menu


func change_menu_color():
	$Resume.color = Color.gray
	$SaveGame.color = Color.gray
	$MainMenu.color = Color.gray
	
	match selected_menu:
		0:
			$Resume.color = Color.greenyellow
		1:
			$SaveGame.color = Color.greenyellow
		2:
			$MainMenu.color = Color.greenyellow


func _input(_event):
	if not visible:
		if Input.is_action_just_pressed("PauseGame"):
			# Pause game
			get_tree().paused = true
			# Reset the popup
			selected_menu = 0
			change_menu_color()
			# Show popup
			player.set_process_input(false)
			popup()
	else:
		if Input.is_action_just_pressed("ui_down"):
			selected_menu = (selected_menu + 1) % 3;
			change_menu_color()
		elif Input.is_action_just_pressed("ui_up"):
			if selected_menu > 0:
				selected_menu = selected_menu - 1
			else:
				selected_menu = 2
			change_menu_color()
		elif Input.is_action_just_pressed("ui_accept"):
			match selected_menu:
				0:
					# Resume game
					if not already_paused:
						get_tree().paused = false
					player.set_process_input(true)
					hide()
				1:
					# Save Game
					get_tree().root.get_node("Game").save()
					get_tree().paused = false
					hide()
				2:
					# Back to start screen
					get_tree().root.get_node("Game").queue_free()
					if(get_tree().change_scene("res://Scenes/StartScreen.tscn")):
						print("Errore nel tornare al menu principale dal menu di pausa")
					get_tree().paused = false
