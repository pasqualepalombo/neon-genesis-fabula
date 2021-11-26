extends Node2D

# Determine which coin type is and which is its value/sprite.
enum coin_type {Bronze, Silver, Gold}
# Make possible to change type directly from the editor
export(coin_type) var which_coin = coin_type.Gold

var coin_value = 1
var player

#DEBUG forse da togliere?
func _process(_delta):
	if Engine.editor_hint:
		if which_coin == coin_type.Bronze:
			$Sprite.region_rect.position.x = 32
			coin_value = 1
		if which_coin == coin_type.Silver:
			$Sprite.region_rect.position.x = 16
			coin_value = 5
		if which_coin == coin_type.Gold:
			$Sprite.region_rect.position.x = 0
			coin_value = 10


func _ready():
	player = get_tree().root.get_node("Game/Player")
	$Sprite.scale = Vector2(1, 1)
	$Sprite.modulate = Color( 1, 1, 1, 1 )
	if which_coin == coin_type.Bronze:
		$Sprite.region_rect.position.x = 32
		coin_value = 1
	if which_coin == coin_type.Silver:
		$Sprite.region_rect.position.x = 16
		coin_value = 5
	if which_coin == coin_type.Gold:
		$Sprite.region_rect.position.x = 0
		coin_value = 10
		

func _on_Area2D_body_entered(body):
	if body.name == "Player":
		if which_coin == coin_type.Bronze:
			$AnimationPlayer.play("GetBronze")
		if which_coin == coin_type.Silver:
			$AnimationPlayer.play("GetSilver")
		if which_coin == coin_type.Gold:
			$AnimationPlayer.play("GetGold")
		player.add_coins(+coin_value)
		$Audio.play()
		yield(get_tree().create_timer(0.5), "timeout") 
		queue_free()
