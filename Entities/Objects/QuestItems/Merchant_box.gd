extends Area2D

var merchant

func _ready():
	merchant = get_parent().get_node("Merchant")


func _on_Merchant_box_body_entered(body):
	if body.name == "Player":
		get_tree().queue_delete(self)
		merchant.boxes_taken += 1
