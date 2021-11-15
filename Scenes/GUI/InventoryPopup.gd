extends Popup

onready var player = get_tree().root.get_node("Game/Player")
var already_paused
var selected_menu = 0
var menu_dic = {}
var item_counter = 0
var selected_slot

func change_menu_color():
	pass


func load_all_stats():
	# Loading General Information
	$General/Coins.bbcode_text = "Coins: " + str(player.coins)
	$General/Reputation.bbcode_text = "Reputation: " + str(player.reputation)
	$General/Level.bbcode_text = "Level: " + str(player.level)
	$General/Experience.bbcode_text = "Experience: " + str(player.experience) + "/" + str(player.xp_next_level)
	
	# Loading Statistics Information
	# TODO
	
	# Loading Inventory Information
	# Quando apro l'inventario, si cicla su quanti item ho in temporary_items e per ognuno, si aggiunge un 
	# figlio slot a Gridcontainer. Nel frattempo, slot ha la sua funzione per caricarsi le info (da all_items).
	# menu_dic è creato per gestire la navigazione dell'utente, item_counter per sapere quanti item ci sono.
	var generic_slot = preload ("res://Scenes/GUI/Slot.tscn")
	for i in ItemHandler.temporary_items:
		var slot = generic_slot.instance()
		slot.change_properties(i)
		$Items/GridContainer.add_child(slot)
		item_counter += 1
		menu_dic[i] = i
	inventory_navigation(0)


func _input(_event):
	if not visible:
		if Input.is_action_just_pressed("inventory"):
			# Pause game
			get_tree().paused = true
			# Reset the popup
			selected_menu = 0
			change_menu_color()
			# Show popup
			player.set_process_input(false)
			popup()
			load_all_stats()
	else:
		if Input.is_action_just_pressed("inventory"):
			get_tree().paused = false
			player.set_process_input(true)
			hide()
			# Inventory Mechanics.
			# Alla chiusura, gli slot di gridcontainer vengono rimossi e reimpostate le variabili
			# item_counter e menu_dic poichè servono per la navigazione dell'inventario
			for i in $Items/GridContainer.get_children():
				$Items/GridContainer.remove_child(i)
			item_counter = 0
			menu_dic = {}
		
		if Input.is_action_just_pressed("ui_up"):
			pass
		if Input.is_action_just_pressed("ui_down"):
			pass
		if Input.is_action_just_pressed("ui_right"):
			inventory_navigation(1)
		if Input.is_action_just_pressed("ui_left"):
			inventory_navigation(-1)


func inventory_navigation(position):
	# Navigation Mechanics
	# se ho degli item, l'istem evidenziato è sempre il primo (grazie a item_navigation(0) di load_all_stats. 
	# Dopo di che ogni volta che ci si sposta, si chiama focus on me per disattivare l'attuale, si calcola quello 
	# nuovo e si richiama il focus sull'attuale. La scelta è delimitata da 0 e item_counter-1.
	# TODO per ora funziona con destra/sinistra, aggiungere +-7 quando si fa su e giu.
	if item_counter > 0:
		selected_menu += position
		if selected_menu < 0:
			selected_menu = item_counter - 1
		if selected_menu > item_counter - 1:
			selected_menu = 0
		if position == 0:
			selected_slot = $Items/GridContainer.get_child(0)
			selected_slot.focus_on_me()
		if position != 0 && selected_menu == 0:
			selected_slot.focus_on_me()
			selected_slot = $Items/GridContainer.get_child(0)
			selected_slot.focus_on_me()
		else:
			selected_slot.focus_on_me()
			selected_slot = $Items/GridContainer.get_child(selected_menu)
			selected_slot.focus_on_me()
		$Items/ItemName.text = selected_slot.get_slot_name()
	else: 
		$Items/ItemName.text = ""


func _ready():
	pass
