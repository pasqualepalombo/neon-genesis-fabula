extends Popup

onready var player = get_tree().root.get_node("Game/Player")
var already_paused
var selected_menu = 0


func change_menu_color():
	$ResumeGame/Void/Icon.hide()
	$SaveGame/Void/Icon.hide()
	$MainMenu/Void/Icon.hide()
	
	match selected_menu:
		0:
			$ResumeGame/Void/Icon.show()
		1:
			$SaveGame/Void/Icon.show()
		2:
			$MainMenu/Void/Icon.show()


func _input(_event):
	if not visible:
		if Input.is_action_just_pressed("PauseGame"):
			# The Game is paused
			get_tree().paused = true
			selected_menu = 0
			change_menu_color()
			player.set_process_input(false)
			popup()
	else:
		if Input.is_action_just_pressed("PauseGame"):
			# Resuming Game
			if not already_paused:
				get_tree().paused = false
			player.set_process_input(true)
			hide()
		if Input.is_action_just_pressed("ui_down"):
			selected_menu = (selected_menu + 1) % 3;
			change_menu_color()
			get_parent().get_node("selectedMenuEffect").play()
		elif Input.is_action_just_pressed("ui_up"):
			if selected_menu > 0:
				selected_menu = selected_menu - 1
			else:
				selected_menu = 2
			change_menu_color()
			get_parent().get_node("selectedMenuEffect").play()
		elif Input.is_action_just_pressed("ui_accept"):
			match selected_menu:
				0:
					# Resuming Game
					if not already_paused:
						get_tree().paused = false
					player.set_process_input(true)
					hide()
				1:
					# Saving game
					get_tree().root.get_node("Game").save()
					get_tree().paused = false
					player.set_process_input(true)
					hide()
				2:
					# Main Menu
					get_tree().root.get_node("Game").queue_free()
					if(get_tree().change_scene("res://Scenes/StartScreen.tscn")):
						print("Errore nel tornare al menu principale dal menu di pausa")
					get_tree().paused = false
			
