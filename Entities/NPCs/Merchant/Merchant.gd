extends StaticBody2D

enum QuestStatus {NOT_STARTED, STARTED, COMPLETED, FAILED }
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = 0
var dialoguePopup
var player
var warehouse


func _ready():
	dialoguePopup = get_tree().root.get_node("Game/GUI/DialoguePopup")
	player = get_tree().root.get_node("Game/Player")
	warehouse = get_tree().root.get_node("Game/Warehouse")
	QuestsList.MerchantQuest = quest_status


func talk(answer = ""):
	$AnimatedSprite.play("talk")
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Merchant"
	
	#Check if at least 3 packed meals are available
	var total_boxes = warehouse.check_packed_meals()
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					if total_boxes == 12:
						dialogue_state = 1
						dialoguePopup.dialogue = "What a wonderful day. Tell me."
						dialoguePopup.answers = Settings.yesKey + " Do you need some help?  " + Settings.nokey + " Nothing"
						dialoguePopup.open()
					if (total_boxes >= 3 and total_boxes < 12) or (total_boxes < 3 and QuestsList.DealerQuest == 0):
						dialogue_state = 1
						dialoguePopup.dialogue = "What? Someone stealed in our warehouse. You know that? Anyway, tell me."
						dialoguePopup.answers = Settings.yesKey + " Do you need some help?  " + Settings.nokey + " Nothing"
						dialoguePopup.open()
					if total_boxes < 3 and (QuestsList.DealerQuest == 1 or QuestsList.DealerQuest == 2):
						dialogue_state = 97
						dialoguePopup.dialogue = "Someone stealed in our warehouse and the city has run out of meals."
						dialoguePopup.answers = Settings.yesKey + " ... "
						dialoguePopup.open()
				1:
					match answer:
						"A":
							dialoguePopup.dialogue = "Uhm. Let me think..."
							dialogue_state = 2
							dialoguePopup.answers = Settings.yesKey + " ... "
							dialoguePopup.open()
						"B":
							dialogue_state = 99
							dialoguePopup.dialogue = "So... Good bye, I think."
							dialoguePopup.answers = Settings.yesKey + " Bye"
							dialoguePopup.open()
				2:
					var item_counter = 0
					var variables 
					for i in ItemHandler.temporary_items.keys():
						if str(i) == "Packed Meal":
							variables = ItemHandler.temporary_items[str(i)]
							item_counter = variables[0]
					dialoguePopup.dialogue = "I'm running out of packed meals. Go to the warehouse and take three of them. I'll pay you 50 bucks."
					if item_counter < 3:
						dialogue_state = 3
						dialoguePopup.answers = Settings.yesKey + "Gotcha. "
						dialoguePopup.open()
					if item_counter == 3:
						dialogue_state = 4
						dialoguePopup.answers = Settings.yesKey + "Already taken. I see the future. " + Settings.nokey + " Okay."
						dialoguePopup.open()
					if item_counter > 3:
						dialogue_state = 5
						dialoguePopup.answers = Settings.yesKey + "Already taken. I see the future. " + Settings.nokey + " Okay."
						dialoguePopup.open()
				3:
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					QuestsList.MerchantQuest = quest_status
					# Close dialogue popup
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
				4:
					match answer:
						"A":
							dialoguePopup.dialogue = "You're weird kiddo, but usefull. Here's 50 bucks. As promised."
							dialogue_state = 98
							dialoguePopup.answers = Settings.yesKey + " Thanks! "
							dialoguePopup.open()
						"B":
							dialogue_state = 0
							dialoguePopup.close()
							$AnimatedSprite.play("idle")
				5:
					match answer:
							"A":
								dialogue_state = 6
								dialoguePopup.dialogue = "I said three. However I'll return the other boxes. "
								dialoguePopup.answers = Settings.yesKey + " ..."
								dialoguePopup.open()
							"B":
								dialogue_state = 99
								dialoguePopup.dialogue = "So? Hurry up."
								dialoguePopup.answers = Settings.yesKey + " Bye"
								dialoguePopup.open()
				6:
					dialoguePopup.dialogue = "You're weird kiddo, but usefull. Here's 50 bucks. As promised."
					dialogue_state = 98
					dialoguePopup.answers = Settings.yesKey + " Thanks! "
					dialoguePopup.open()
				97:
					dialogue_state = 0
					quest_status = QuestStatus.FAILED
					QuestsList.MerchantQuest = quest_status
					player.add_reputation(-10)
					dialoguePopup.close()
					$AnimatedSprite.play("idle") 
				98:
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					QuestsList.MerchantQuest = quest_status
					dialoguePopup.close()
					$AnimatedSprite.play("idle") 
					player.add_reputation(10)
					player.add_coins(+50)
					player.add_xp(100)
					remove_meals()
					yield(get_tree().create_timer(0.5), "timeout") 
				99:
					dialogue_state = 0
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
	
		QuestStatus.STARTED:
			var item_counter = 0
			var variables 
			for i in ItemHandler.temporary_items.keys():
				if str(i) == "Packed Meal":
					variables = ItemHandler.temporary_items[str(i)]
					item_counter = variables[0]
			if item_counter <3 and total_boxes >= 3:
				match dialogue_state:
					0:
						dialogue_state = 99
						dialoguePopup.dialogue = "The boxes. In the warehouse."
						dialoguePopup.answers = Settings.yesKey + " Yeah, right."
						dialoguePopup.open()
					99:
						dialogue_state = 0
						dialoguePopup.close()
						$AnimatedSprite.play("idle")
			if item_counter <3 and total_boxes < 3:
				match dialogue_state:
					0:
						dialogue_state = 99
						dialoguePopup.dialogue = "Give up kid. There aren't enough meals in the warehouse."
						dialoguePopup.answers = Settings.yesKey + " ..."
						dialoguePopup.open()
					99:
						dialogue_state = 0
						quest_status = QuestStatus.FAILED
						QuestsList.MerchantQuest = quest_status
						player.add_reputation(-10)
						dialoguePopup.close()
						$AnimatedSprite.play("idle")
			if item_counter == 3:
				match dialogue_state:
					0:
						dialogue_state = 1
						dialoguePopup.dialogue = "Okay kiddo, have you got my packed meals?"
						dialoguePopup.answers = Settings.yesKey + " Yes, mister. " + Settings.nokey + " Not yet"
						dialoguePopup.open()
					1:
						match answer:
							"A":
								dialoguePopup.dialogue = "Great. Good job kiddo. Here's 50 bucks. As promised."
								dialogue_state = 98
								dialoguePopup.answers = Settings.yesKey + " Thanks! "
								dialoguePopup.open()
							"B":
								dialogue_state = 99
								dialoguePopup.dialogue = "So? Hurry up."
								dialoguePopup.answers = Settings.yesKey + " Bye"
								dialoguePopup.open()
					98:
						dialogue_state = 0
						quest_status = QuestStatus.COMPLETED
						QuestsList.MerchantQuest = quest_status
						remove_meals()
						dialoguePopup.close()
						$AnimatedSprite.play("idle") 
						player.add_reputation(10)
						player.add_coins(+50)
						player.add_xp(100)
						yield(get_tree().create_timer(0.5), "timeout") 
					99:
						dialogue_state = 0
						dialoguePopup.close()
						$AnimatedSprite.play("idle")
			if item_counter > 3:
				match dialogue_state:
					0:
						dialogue_state = 1
						dialoguePopup.dialogue = "Okay kiddo, have you got my packed meals?"
						dialoguePopup.answers = Settings.yesKey + " Yes, mister. " + Settings.nokey + " Not yet"
						dialoguePopup.open()
					1:
						match answer:
							"A":
								dialogue_state = 98
								dialoguePopup.dialogue = "I said three. However I'll return the other boxes. "
								dialoguePopup.answers = Settings.yesKey + " ..."
								dialoguePopup.open()
							"B":
								dialogue_state = 99
								dialoguePopup.dialogue = "So? Hurry up."
								dialoguePopup.answers = Settings.yesKey + " Bye"
								dialoguePopup.open()
					98:
						dialogue_state = 0
						quest_status = QuestStatus.COMPLETED
						QuestsList.MerchantQuest = quest_status
						remove_meals()
						dialoguePopup.close()
						$AnimatedSprite.play("idle") 
						player.add_reputation(10)
						player.add_coins(+50)
						player.add_xp(100)
						yield(get_tree().create_timer(0.5), "timeout") 
					99:
						dialogue_state = 0
						dialoguePopup.close()
						$AnimatedSprite.play("idle")
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "If I need help, I'll call you. Bye."
					dialoguePopup.answers = Settings.yesKey + " Bye"
					dialoguePopup.open()
				1:
					dialogue_state = 0
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
		QuestStatus.FAILED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "And now what can I do? Damn."
					dialoguePopup.answers = Settings.yesKey + " ..."
					dialoguePopup.open()
				1:
					dialogue_state = 0
					dialoguePopup.close()
					$AnimatedSprite.play("idle")



func remove_meals():
	ItemHandler.temporary_items.erase('Packed Meal')


func to_dictionary():
	return {
		"quest_status" : quest_status,
	}


func from_dictionary(data):
	quest_status = int(data.quest_status)
	QuestsList.MerchantQuest = quest_status
