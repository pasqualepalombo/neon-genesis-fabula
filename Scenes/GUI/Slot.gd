extends Panel

var ItemName

func change_properties(item):
	var keys = ItemHandler.temporary_items.keys()
	for i in keys:
		if str(item) == str(i):
			ItemName = str(i)
			var variables = ItemHandler.temporary_items[item]
			$SpriteSlot.region_rect = Rect2(variables[1], variables[2], 16, 16)
			if variables[0] == 0:
				$LabelSlot.text = "" 
			else:
				$LabelSlot.text = str(variables[0])


func focus_on_me():
	$SelectedSlot.visible = !$SelectedSlot.visible

func get_slot_name():
	return ItemName
