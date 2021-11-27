# DEBUG questo file è solo per lo sviluppo

extends RichTextLabel

func _ready():
	get_parent().get_parent().get_node("DEBUGrect").visible = false
	bbcode_enabled = true
	bbcode_text = ""


func _input(event):
	# DEBUG 
	if event is InputEventKey:
		# The correct key is debug1. 
		if event.is_action_pressed("debugx"):
			get_parent().get_parent().get_node("DEBUGrect").visible = !get_parent().get_parent().get_node("DEBUGrect").visible
			writeQuestList()
			
func writeQuestList():
	bbcode_text = "Quest progression: "
	bbcode_text += "\nMedicine Quest: " + str(QuestsList.MedicineQuest) 
	bbcode_text += "\nMerchant Quest: " + str(QuestsList.MerchantQuest)
	bbcode_text += "\nDoctor Quest: " + str(QuestsList.DoctorQuest)
	bbcode_text += "\nDealer Quest: " + str(QuestsList.DealerQuest)
