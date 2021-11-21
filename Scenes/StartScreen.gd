extends Node2D

var selected_menu = 0

func change_menu_color():
	$NewGame/Void/Icon.hide()
	$LoadGame/Void/Icon.hide()
	$Settings/Void/Icon.hide()
	$QuitGame/Void/Icon.hide()
	
	match selected_menu:
		0:
			$NewGame/Void/Icon.show()
		1:
			$LoadGame/Void/Icon.show()
		2:
			$Settings/Void/Icon.show()
		3:
			$QuitGame/Void/Icon.show()

func _ready():
	change_menu_color()
	$AnimationPlayer.play("starterscreen")

func _input(_event):
	if Input.is_action_just_pressed("ui_down"):
		selected_menu = (selected_menu + 1) % 4;
		change_menu_color()
		$SelectedMenuEffect.play()
	elif Input.is_action_just_pressed("ui_up"):
		if selected_menu > 0:
			selected_menu = selected_menu - 1
		else:
			selected_menu = 3
		$SelectedMenuEffect.play()
		change_menu_color()
	elif Input.is_action_just_pressed("ui_accept"):
		match selected_menu:
			0:
				# New game
				reset_game_stats()
				if(get_tree().change_scene("res://Scenes/Game.tscn")):
					print("Errore nel caricare il gioco da menu principale")
			1:
				# Load game
				var next_level_resource = load("res://Scenes/Game.tscn");
				var next_level = next_level_resource.instance()
				next_level.load_saved_game = true
				get_tree().root.call_deferred("add_child", next_level)
				queue_free()
			2:
				#TODO setting (un popup giust con l'audio)
				pass
			3:
				# Quit game
				get_tree().quit()


func reset_game_stats():
	ItemHandler.temporary_items = {}
