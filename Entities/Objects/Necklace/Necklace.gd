extends Area2D

var fiona

func _ready():
	fiona = get_parent().get_node("Fiona")


func _on_Necklace_body_entered(body):
	if body.name == "Player":
		get_tree().queue_delete(self)
		fiona.necklace_found = true
