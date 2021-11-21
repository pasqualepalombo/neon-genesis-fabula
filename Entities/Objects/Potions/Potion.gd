tool

extends Area2D

enum Potion { HEALTH, MANA, MEDICINE, BOH }
export(Potion) var type = Potion.HEALTH

func _ready():
	if type == Potion.HEALTH:
		$Sprite.region_rect.position.x = 0
	elif type == Potion.MANA:
		$Sprite.region_rect.position.x = 8
	elif type == Potion.MEDICINE:
		$Sprite.region_rect.position.x = 16
	elif type == Potion.BOH:
		$Sprite.region_rect.position.x = 24


func _process(_delta):
	if Engine.editor_hint:
		if type == Potion.HEALTH:
			$Sprite.region_rect.position.x = 0
		elif type == Potion.MANA:
			$Sprite.region_rect.position.x = 8
		elif type == Potion.MEDICINE:
			$Sprite.region_rect.position.x = 16
		elif type == Potion.BOH:
			$Sprite.region_rect.position.x = 24


func _on_Potion_body_entered(body):
	if body.name == "Player":
		body.add_potion(type)
		get_tree().queue_delete(self)
