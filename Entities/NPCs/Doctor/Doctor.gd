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
	QuestsList.DoctorQuest = quest_status
	# BUG dovrebbe chiamare la funzione, ma non lo fa, e perciò non mi si aggiorna la GUI in carica partita
	if medicine_bought and QuestsList.MedicineQuest != 2:
		player.add_questitem_in_GUI(0,0,"notext")


func talk(answer = ""):
	$AnimatedSprite.play("talk")
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Doctor"
	
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Hello boy! How can I assist you?"
					dialoguePopup.answers = Settings.yesKey + " I need mom's medicine  " + Settings.nokey + " Nothing"
					dialoguePopup.open()
				1:
					match answer:
						"A":
							dialoguePopup.dialogue = "Sure. It costs 100 bucks."
							if player.coins >= 100:
								dialogue_state = 2
								dialoguePopup.answers = Settings.yesKey + " Deal. " + Settings.nokey + " I'll be right back"
							else:
								dialogue_state = 4
								dialoguePopup.answers = Settings.yesKey + " I'll be right back"
							dialoguePopup.open()
						"B":
							dialogue_state = 4
							dialoguePopup.dialogue = "If you change your mind, you'll find me here."
							dialoguePopup.answers = Settings.yesKey + " Bye"
							dialoguePopup.open()
				2:
					match answer:
						"A":
							dialogue_state = 0
							quest_status = QuestStatus.COMPLETED
							QuestsList.DoctorQuest = quest_status
							medicine_bought = true
							dialoguePopup.close()
							$AnimatedSprite.play("idle")
							player.add_coins(-100)
							player.add_xp(100)
							player.add_questitem_in_GUI(0,0,"notext")
							yield(get_tree().create_timer(0.5), "timeout")
						"B":
							dialogue_state = 4
							dialoguePopup.dialogue = "If you change your mind, you'll find me here."
							dialoguePopup.answers = Settings.yesKey + " Bye"
							dialoguePopup.open()
				4:
					dialogue_state = 0
					dialoguePopup.close()
					$AnimatedSprite.play("idle")
		
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					dialogue_state = 1
					dialoguePopup.dialogue = "Comeback for buying!"
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
	QuestsList.DoctorQuest = quest_status
