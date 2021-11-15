extends Area2D

var merchant
var dealer

func _ready():
	merchant = get_parent().get_node("Merchant")
	dealer = get_parent().get_node("SHDealer")


func _on_Merchant_box_body_entered(body):
	if body.name == "Player":
		ItemHandler.add_to_all_items_dictionary("Packed Meal", 1, 64, 0)
		ItemHandler.add_to_temporary_items_dictionary("Packed Meal", 1, 64, 0)
		get_tree().queue_delete(self)
		# TODO questo per ora lo lascio ma lo tolgo quando finisco tutto il sistema item
		merchant.boxes_taken += 1
		dealer.boxes_taken += 1
