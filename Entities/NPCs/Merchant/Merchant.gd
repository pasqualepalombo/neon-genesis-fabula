extends StaticBody2D

enum QuestStatus {NOT_STARTED, STARTED, COMPLETED }
var quest_status = QuestStatus.NOT_STARTED
var dialogue_state = 0
var boxes_taken = 0
var dialoguePopup
var player
enum Potion { HEALTH, MANA }


func _ready():
	dialoguePopup = get_tree().root.get_node("Game/GUI/DialoguePopup")
	player = get_tree().root.get_node("Game/Player")


func talk(answer = ""):
	# Set Merchant's animation to "talk"
	$AnimatedSprite.play("talk")
	
	# Set dialoguePopup npc to Merchant
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Merchant"
	
	# Show the current dialogue
	match quest_status:
		QuestStatus.NOT_STARTED:
			match dialogue_state:
				0:
					# Update dialogue tree state
					dialogue_state = 1
					# Show dialogue popup
					dialoguePopup.dialogue = "What a wonderful day. Tell me."
					dialoguePopup.answers = "[E]Do you need some help?  [Shift] Nothing"
					dialoguePopup.open()
				1:
					match answer:
						"A":
							# Show dialogue popup
							dialoguePopup.dialogue = "Uhm. Let me think..."
							# Update dialogue tree state: wanna buy but I don't have the money
							dialogue_state = 2
							dialoguePopup.answers = "[E] ... "
							dialoguePopup.open()
						"B":
							# Update dialogue tree state
							dialogue_state = 99
							# Show dialogue popup
							dialoguePopup.dialogue = "So... Good bye, I think."
							dialoguePopup.answers = "[E] Bye"
							dialoguePopup.open()
				2:
					# Show dialogue popup
					dialoguePopup.dialogue = "I'm running out of packed meals. Go to the warehouse and take three of them. I'll pay you 50 bucks."
					# Update dialogue tree state: wanna buy but I don't have the money
					dialogue_state = 3
					dialoguePopup.answers = "[E] Gotcha. "
					dialoguePopup.open()
				3:
					# Update dialogue tree state
					dialogue_state = 0
					quest_status = QuestStatus.STARTED
					# Close dialogue popup
					dialoguePopup.close()
					# Set Merchant's animation to "idle"
					$AnimatedSprite.play("idle")
				99:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Merchant's animation to "idle"
					$AnimatedSprite.play("idle")
		QuestStatus.STARTED:
			match dialogue_state:
				0:
					#TODO se ha le casse deve fare altro, sennò parla e basta.
					# Update dialogue tree state
					dialogue_state = 99
					# Show dialogue popup
					dialoguePopup.dialogue = "The boxes. In the warehouse."
					dialoguePopup.answers = "[E] Yeah, right."
					dialoguePopup.open()
				99:
					# Update dialogue tree state
					dialogue_state = 0
					# Close dialogue popup
					dialoguePopup.close()
					# Set Merchant's animation to "idle"
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
					# Set Merchant's animation to "idle"
					$AnimatedSprite.play("idle")


func to_dictionary():
	return {
		"quest_status" : quest_status,
		"boxes_taken" : boxes_taken
	}


func from_dictionary(data):
	boxes_taken = data.boxes_taken
	quest_status = int(data.quest_status)
