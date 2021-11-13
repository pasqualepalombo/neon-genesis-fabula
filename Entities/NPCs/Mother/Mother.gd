extends StaticBody2D

enum QuestStatus {NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = 0
var medicine_bought = false
var dialoguePopup
var player


func _ready():
	dialoguePopup = get_tree().root.get_node("Game/GUI/DialoguePopup")
	player = get_tree().root.get_node("Game/Player")
	QuestsList.MedicineQuest = quest_status


func talk(answer = ""):
	$AnimatedSprite.play("talk")
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Mother"
	
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Dear Child, I ran out of medicine. Can you go the doctor? Please."
					dialoguePopup.answers = Settings.yesKey + " Yes mom  " + Settings.nokey + " No. I'm busy"
					dialoguePopup.open()
				1:
					match answer:
						"A":
							dialogue_state = 2
							dialoguePopup.dialogue = "Thank you, my boy. I'll wait here."
							dialoguePopup.answers = Settings.yesKey + " Bye"
							dialoguePopup.open()
						"B":
							dialogue_state = 3
							dialoguePopup.dialogue = "Than... oh wait. I need them. Please."
							dialoguePopup.answers = Settings.yesKey + " Bye"
							dialoguePopup.open()
				2:
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					QuestsList.MedicineQuest = quest_status
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
				3:
					dialogue_state = 0
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Did you buy my medicine, sweet child?"
					if medicine_bought:
						dialoguePopup.answers = Settings.yesKey + " Yes, here you are  " + Settings.nokey + " [Lie] Not yet"
					else:
						dialoguePopup.answers = Settings.yesKey + " No"
					dialoguePopup.open()
				1:
					if medicine_bought and answer == "A":
						dialogue_state = 2
						dialoguePopup.dialogue = "A gentleman, like your father. You're really kind."
						dialoguePopup.answers = Settings.yesKey + " Thanks"
						dialoguePopup.open()
					else:
						dialogue_state = 3
						dialoguePopup.dialogue = "Ok, but don't take it so long."
						dialoguePopup.answers = Settings.yesKey + " I will!"
						dialoguePopup.open()
				2:
					dialogue_state = 0
					quest_status = QuestStatus.COMPLETED
					QuestsList.MedicineQuest = quest_status
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
					yield(get_tree().create_timer(0.5), "timeout")
					player.add_xp(150)
					player.add_reputation(10)
					#TODO 
					#player.add_potion(Potion.HEALTH)
				3:
					dialogue_state = 0
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Now I'm fine. Thanks to you."
					dialoguePopup.answers = Settings.yesKey + " Bye"
					dialoguePopup.open()
				1:
					dialogue_state = 0
					dialoguePopup.close()
					$AnimatedSprite.play("idle")


func to_dictionary():
	return {
		"quest_status" : quest_status,
		"medicine_bought" : medicine_bought
	}


func from_dictionary(data):
	medicine_bought = data.medicine_bought
	quest_status = int(data.quest_status)
	QuestsList.MedicineQuest = quest_status
