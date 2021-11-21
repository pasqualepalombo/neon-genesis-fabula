extends Area2D


func _on_Merchant_box_body_entered(body):
	if body.name == "Player":
		ItemHandler.add_to_temporary_items_dictionary("Packed Meal", 1, 64, 0)
		get_tree().queue_delete(self)
