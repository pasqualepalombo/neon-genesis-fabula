extends StaticBody2D

var dialogue_state = 0
var dialoguePopup

func _ready():
	dialoguePopup = get_tree().root.get_node("Game/GUI/DialoguePopup")


func talk(answer = ""):
	dialoguePopup.npc = self
	dialoguePopup.npc_name = "Bullettin Board"
	
	match dialogue_state:
		0:
			dialogue_state += 1
			dialoguePopup.dialogue = "The Humble Fork.\nHome of majestic packed meals by Willem Jambalaya."
			dialoguePopup.answers = ""
			dialoguePopup.open()
		1:
			dialogue_state -= 1
			dialoguePopup.close()
