extends ColorRect

#must connect the player_stats_changed from player to this node. this signal is also called when player spawn.

func _ready():
	pass


func player_stats_changed():
	print("ciao")
