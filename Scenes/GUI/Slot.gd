extends Panel


func change_properties(item):
	var keys = ItemHandler.temporary_items.keys()
	for i in keys:
		if str(item) == str(i):
			var variables = ItemHandler.temporary_items[item]
			$SpriteSlot.region_rect = Rect2(variables[1], variables[2], 16, 16)
			if variables[0] == 0:
				$LabelSlot.text = "" 
			else:
				$LabelSlot.text = str(variables[0])
