extends StaticBody2D

enum QuestStatus {NOT_STARTED, STARTED, COMPLETED, FAILED}
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = 0
var dialoguePopup
var player
var boxes_taken = 0
var warehouse


func _ready():
	dialoguePopup = get_tree().root.get_node("Game/GUI/DialoguePopup")
	player = get_tree().root.get_node("Game/Player")
	warehouse = get_tree().root.get_node("Game/Warehouse")
	QuestsList.DealerQuest = quest_status

func talk(answer = ""):
	$AnimatedSprite.play("talk")
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Dealer"
	
	#Check if at least 3 packed meals are available
	var total_boxes = warehouse.check_packed_meals()
	
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Oh. Ehy. Listen up."
					dialoguePopup.answers = Settings.yesKey + " ...yes?  "
					dialoguePopup.open()
				1:
					dialogue_state = 2
					dialoguePopup.dialogue = "Have you seen those piled boxes? I'll pay you 10 bucks each. We have a Deal?"
					dialoguePopup.answers = Settings.yesKey + " Deal. Prepare the cash." + Settings.nokey + " Is legal stuff?"
					dialoguePopup.open()
				2:
					match answer:
						"A":
							dialogue_state = 3
							dialoguePopup.dialogue = "Nice to hear. But be cool, that's simply food."
							dialoguePopup.answers = Settings.yesKey + " I'll be right back."
							dialoguePopup.open()
						"B":
							dialogue_state = 4
							dialoguePopup.dialogue = "...Yes. Of course. But, you know, I've change my mind. Piss off."
							dialoguePopup.answers = Settings.yesKey + " Bye"
							player.add_reputation(5)
							dialoguePopup.open()
				3:
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					QuestsList.DealerQuest = quest_status
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
				4:
					dialogue_state = 0
					quest_status = QuestStatus.FAILED
					QuestsList.DealerQuest = quest_status
					dialoguePopup.close()
					$AnimatedSprite.play("idle")

		QuestStatus.STARTED:
			var item_counter = 0
			var variables 
			for i in ItemHandler.temporary_items.keys():
				if str(i) == "Packed Meal":
					variables = ItemHandler.temporary_items[str(i)]
					item_counter = variables[0]
			match dialogue_state:
				0:
					if (boxes_taken + item_counter) == 12:
						dialogue_state = 1
						dialoguePopup.dialogue = "And we're done. All the " + str(item_counter) + " meals. Here you are, " + str(item_counter*10) + " bucks."
						dialoguePopup.answers = Settings.yesKey + " Here you are." + Settings.nokey + " Wait."
						dialoguePopup.open()
					else:
						if total_boxes+item_counter > 0:
							if item_counter == 0:
								dialogue_state = 99
								dialoguePopup.dialogue = "C'mon. I don't have all day. Or maybe yes."
								dialoguePopup.answers = Settings.yesKey + " Wait."
								dialoguePopup.open()
							if item_counter == 1:
								dialogue_state = 1
								dialoguePopup.dialogue = "Just one? Better than nothing. 10 bucks for you."
								dialoguePopup.answers = Settings.yesKey + " Thanks." + Settings.nokey + " Wait."
								dialoguePopup.open()
							if item_counter > 1:
								dialogue_state = 1
								dialoguePopup.dialogue = "Oh yes. " + str(item_counter) + " meals. Sounds good. " + str(item_counter*10) + " bucks."
								dialoguePopup.answers = Settings.yesKey + " Here you are." + Settings.nokey + " Wait."
								dialoguePopup.open()
						else:
							dialogue_state = 98
							dialoguePopup.dialogue = "Warehouse is empty. Pocket is full."
							dialoguePopup.answers = Settings.yesKey + " Hell yeah."
							dialoguePopup.open()
				1:
					match answer:
						"A":
							dialogue_state = 0
							boxes_taken += item_counter
							if boxes_taken == 12:
								quest_status = QuestStatus.COMPLETED
								QuestsList.DealerQuest = quest_status
							remove_meals()
							player.add_reputation(-5*boxes_taken)
							player.add_coins(item_counter*10)
							dialoguePopup.close()
							$AnimatedSprite.play("idle")
						"B":
							dialogue_state = 0
							dialoguePopup.close()
							$AnimatedSprite.play("idle")
				98:
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					QuestsList.DealerQuest = quest_status
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
				99:
					dialogue_state = 0
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
				
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Good job, small one. That's a pity that the meals runned out"
					dialoguePopup.answers = Settings.yesKey + " ..."
					dialoguePopup.open()
				1:
					dialogue_state = 0
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
		QuestStatus.FAILED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Piss off, I said.."
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

