extends StaticBody2D

enum sign_name {S1, S2, S3}
# Make possible to change type directly from the editor
export(sign_name) var which_sign = sign_name.S1
var dialogue_state = 0
var dialoguePopup

func _ready():
	dialoguePopup = get_tree().root.get_node("Game/GUI/DialoguePopup")
	set_initial_property()


func set_initial_property():
	if which_sign == sign_name.S1:
		dialogue_state = 0
	elif which_sign == sign_name.S2:
		dialogue_state = 2
	elif which_sign == sign_name.S3:
		dialogue_state = 4

func talk(answer = ""):
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Woodsign"
	
	match dialogue_state:
		0:
			dialogue_state += 1
			dialoguePopup.dialogue = "Rising Dawn. The grey city."
			dialoguePopup.answers = ""
			dialoguePopup.open()
		1:
			dialogue_state -= 1
			dialoguePopup.close()
		2:
			dialogue_state += 1
			dialoguePopup.dialogue = "Watch out ahead. Trespasser will be killed (by monsters)."
			dialoguePopup.answers = ""
			dialoguePopup.open()
		3:
			dialogue_state -= 1
			dialoguePopup.close()
		4:
			dialogue_state += 1
			dialoguePopup.dialogue = "Next opening this fall: the bridge to the city and beyond."
			dialoguePopup.answers = ""
			dialoguePopup.open()
		5:
			dialogue_state -= 1
			dialoguePopup.close()
