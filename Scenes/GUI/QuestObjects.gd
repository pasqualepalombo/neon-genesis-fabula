extends ColorRect


func _ready():
	if(get_parent().get_parent().get_node("Player").connect("player_additem_to_gui", self, "on_player_additem_to_gui") != 0):
		print("Signal Connection Error: PLAYER->GUI(QuestObjects) player_additem_to_gui")
	#TODO check on ready if player own the medicine (or the generic object)
	self.visible = false


func on_player_additem_to_gui(x, y, text):
	self.visible = true
	if (text == "notext"):
		$Label.text = ""
		self.rect_size.x = 18
		self.rect_position.x = 281 + 18
	else: 
		$Label.text = text
		self.rect_size.x = 36
		self.rect_position.x = 281
	$Sprite.region_rect = Rect2(int(16 * x), int(16 * y), 16, 16)

