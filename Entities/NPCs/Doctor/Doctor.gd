extends StaticBody2D

enum QuestStatus {NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = 0
var medicine_bought = false
var dialoguePopup
var player
enum Potion { HEALTH, MANA }


func _ready():
	dialoguePopup = get_tree().root.get_node("Game/GUI/DialoguePopup")
	player = get_tree().root.get_node("Game/Player")
	QuestsList.DoctorQuest = quest_status
	# BUG dovrebbe chiamare la funzione, ma non lo fa, e perciò non mi si aggiorna la GUI in carica partita
	if medicine_bought and QuestsList.MedicineQuest != 2:
		player.add_questitem_in_GUI(0,0,"notext")


func talk(answer = ""):
	# Set Doctor's animation to "talk"
	$AnimatedSprite.play("talk")
	
	# Set dialoguePopup npc to Doctor
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Doctor"
	
	# Show the current dialogue
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Hello boy! How can I assist you?"
					dialoguePopup.answers = "[E] I need mom's medicine  [Shift] Nothing"
					dialoguePopup.open()
				1:
					match answer:
						"A":
							# Show dialogue popup
							dialoguePopup.dialogue = "Sure. It costs 20 bucks."
							if player.coins >= 20:
								# Update dialogue tree state: wanna buy and I have the money
								dialogue_state = 2
								dialoguePopup.answers = "[E] Deal. [Shift] I'll be right back"
							else:
								# Update dialogue tree state: wanna buy but I don't have the money
								dialogue_state = 4
								dialoguePopup.answers = "[E] I'll be right back"
							dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 4
							# Show dialogue popup
							dialoguePopup.dialogue = "If you change your mind, you'll find me here."
							dialoguePopup.answers = "[E] Bye"
							dialoguePopup.open()
				2:
					match answer:
						"A":
							# I have the money and i wanna buy
							# Update dialogue tree state
							dialogue_state = 0
							quest_status = QuestStatus.COMPLETED
							QuestsList.DoctorQuest = quest_status
							medicine_bought = true
							# Close dialogue popup
							dialoguePopup.close()
							# Set Doctor's animation to "idle"
							$AnimatedSprite.play("idle")
							# Add potion and XP to the player. 
							player.add_coins(-20)
							player.add_xp(100)
							player.add_questitem_in_GUI(0,0,"notext")
							yield(get_tree().create_timer(0.5), "timeout") #I added a little delay in case the level advancement panel appears.
						"B":
							# I have the money and i don't wanna buy
							# Update dialogue tree state
							dialogue_state = 4
							# Show dialogue popup
							dialoguePopup.dialogue = "If you change your mind, you'll find me here."
							dialoguePopup.answers = "[E] Bye"
							dialoguePopup.open()
				4:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Doctor's animation to "idle"
					$AnimatedSprite.play("idle")
		
		QuestStatus.COMPLETED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "Comeback for buying!"
					dialoguePopup.answers = "[E] Bye"
					dialoguePopup.open()
				1:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Doctor's animation to "idle"
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
