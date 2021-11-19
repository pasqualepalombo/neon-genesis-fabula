extends Node2D

func _ready():
	$Roof.visible = true
	$Interior.visible = true
	$Wall2.visible = false

func _on_RoofHiding_body_entered(body):
	if body.name == "Player":
		$Wall2.visible = true
		$Roof.hide()


func _on_RoofHiding_body_exited(body):
	if body.name == "Player":
		$Wall2.visible = false
		$Roof.show()
