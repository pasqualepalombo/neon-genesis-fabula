extends Node

var all_items = {
	"Health Potion" : [2,0,0], "Mana Potion" : [3,16,0], 
	"Mom Medicine" : [0, 48, 0], "Packed Meal" : [0,64,0]
	}

var temporary_items = {}


func add_to_all_items_dictionary(key, value, x, y):
	if all_items.has(key):
		all_items[str(key)] = [all_items[str(key)][0]+1,x,y]
	else:
		all_items[str(key)] = [value,x,y]


func add_to_temporary_items_dictionary(key, value, x, y):
	if temporary_items.has(key):
		temporary_items[str(key)] = [temporary_items[str(key)][0]+1,x,y]
	else:
		temporary_items[str(key)] = [value,x,y]


func _ready():
	pass
