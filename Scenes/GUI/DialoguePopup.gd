extends Popup

# sto al punto Dialogue popup script e ho aggiunto questi script
var npc_name setget name_set
var dialogue setget dialogue_set
var answers setget answers_set

func name_set(new_value):
	npc_name = new_value
	$ColorRect/NPCName.text = new_value

func dialogue_set(new_value):
	dialogue = new_value
	$ColorRect/Dialogue.text = new_value

func answers_set(new_value):
	answers = new_value
	$ColorRect/Answers.text = new_value
