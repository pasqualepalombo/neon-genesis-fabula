extends StaticBody2D

enum QuestStatus {NOT_STARTED, STARTED, COMPLETED, FAILED }
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = 0
#TODO fare come il dealer e contare le casse con i temporary items
var boxes_taken = 0
var dialoguePopup
var player


func _ready():
	dialoguePopup = get_tree().root.get_node("Game/GUI/DialoguePopup")
	player = get_tree().root.get_node("Game/Player")
	QuestsList.MerchantQuest = quest_status


func talk(answer = ""):
	$AnimatedSprite.play("talk")
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Merchant"
	
	match quest_status:
		QuestStatus.NOT_STARTED:
			#TODO se non ci sono più casse (o cmq meno di tre) deve dire tipo "che giornataccia, non c'è cibo. ciao"
			# e non può proprio farti partire la quest e la mette fallita
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "What a wonderful day. Tell me."
					dialoguePopup.answers = Settings.yesKey + " Do you need some help?  " + Settings.nokey + " Nothing"
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
					dialoguePopup.dialogue = "I'm running out of packed meals. Go to the warehouse and take three of them. I'll pay you 50 bucks."
					if boxes_taken < 3:
						dialogue_state = 3
						dialoguePopup.answers = Settings.yesKey + "Gotcha. "
						dialoguePopup.open()
					if boxes_taken == 3:
						dialogue_state = 4
						dialoguePopup.answers = Settings.yesKey + "Already taken. I see the future. " + Settings.nokey + " Okay."
						dialoguePopup.open()
					if boxes_taken >= 3:
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
				98:
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					QuestsList.MerchantQuest = quest_status
					dialoguePopup.close()
					$AnimatedSprite.play("idle") 
					player.add_coins(+50)
					player.add_xp(100)
					yield(get_tree().create_timer(0.5), "timeout") 
					# TODO rimuovere le casse dall'inventario
				99:
					dialogue_state = 0
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
	
		QuestStatus.STARTED:
			#TODO se nel frattempo le casse sono finite allora ti dirà "grazie lo stesso, ma qualcuno ha rubato
			# nel magazzino e la mette fallita
			if boxes_taken <3:
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
			if boxes_taken == 3:
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
						dialoguePopup.close()
						$AnimatedSprite.play("idle") 
						player.add_coins(+50)
						player.add_xp(100)
						yield(get_tree().create_timer(0.5), "timeout") 
						# TODO rimuovere le casse dall'inventario
					99:
						dialogue_state = 0
						dialoguePopup.close()
						$AnimatedSprite.play("idle")
			if boxes_taken >= 3:
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
						dialoguePopup.close()
						$AnimatedSprite.play("idle") 
						player.add_coins(+50)
						player.add_xp(100)
						yield(get_tree().create_timer(0.5), "timeout") 
						# TODO rimuovere le casse in più oltre quelle della quest
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


func to_dictionary():
	return {
		"quest_status" : quest_status,
		"boxes_taken" : boxes_taken
	}


func from_dictionary(data):
	boxes_taken = data.boxes_taken
	quest_status = int(data.quest_status)
	QuestsList.MerchantQuest = quest_status
