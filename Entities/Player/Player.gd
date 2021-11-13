#BUG #TODO When player sleep, during the Sleep Animation, He can moves around
#BUG Quando il player apre l'inventario, poi preme menu e preme il tasto salva
# o riprendi, rimane l'inventario aperto ma il player si può muovere, non comporta
# problemi ma prima o poi bisogna sistemarlo

extends KinematicBody2D

# Connected to the GUI/HealthBar, with all the variables. 
signal player_stats_changed(Player)
# Connected to the GUI, with all the variables. 
signal player_sleep(Player)
# Connected to the GUI/LevelPopup, with all the variables. 
signal player_level_up()
# Connecter to the GUI/QuestObject
signal player_additem_to_gui()

# Player general variable for movements and extra
var speed = 75
var health = 100
var health_max = 100
var health_regeneration = 1
var mana = 100
var mana_max = 100
var mana_regeneration = 2
var coins = 0
var reputation = 0
var experience = 0
var level = 1
var xp_next_level = 100
var attack_damage = 30
enum Potion { HEALTH, MANA }
var health_potions = 0 #CHECK
var mana_potions = 0 #CHECK
# Memorizza l'ultima direzione presa.
var last_direction = Vector2(0,1)
# Attack variables
var attack_cooldown_time = 1000
var next_attack_time = 0
var attack_playing = false


func _ready():
	emit_signal("player_stats_changed", self)


func _process(delta):
	# Health and Mana Regeneration
	var new_health = min(health + health_regeneration * delta, health_max)
	if new_health != health:
		health = new_health
		emit_signal("player_stats_changed", self)
	var new_mana = min(mana + mana_regeneration * delta, mana_max)
	if new_mana != mana:
		mana = new_mana
		emit_signal("player_stats_changed", self)


func _physics_process(delta):
	# Direction
	var direction: Vector2
	direction.x = Input.get_action_strength("ui_right") - Input.get_action_strength("ui_left")
	direction.y = Input.get_action_strength("ui_down") - Input.get_action_strength("ui_up")
	
	if abs(direction.x) == 1 and abs(direction.y) == 1:
		direction = direction.normalized()
	
	var movement = speed * direction * delta
	if attack_playing:
		movement = 0.3 * movement
	# warning-ignore:return_value_discarded
	move_and_collide(movement)
	# the engine can't change the animation if player's attacking
	if not attack_playing:
		player_animations_handler(direction)
	# Turn RayCast2D toward movement direction
	if direction != Vector2.ZERO:
		$RayCast2D.cast_to = direction.normalized() * 8


func player_animations_handler(direction: Vector2):
	if direction != Vector2.ZERO:
		#Analog stick bounce problem
		last_direction = 0.5 * last_direction + 0.5 * direction
		var animation = get_direction_for_animation(last_direction) + "_walk"
		#Joypad FPS adjusting
		$AnimatedSprite.frames.set_animation_speed(animation, 2 + 8 * direction.length())
		$AnimatedSprite.play(animation)
	else:
		var animation = get_direction_for_animation(last_direction) + "_idle"
		$AnimatedSprite.play(animation)


func get_direction_for_animation(direction: Vector2):
	var norm_direction = direction.normalized()
	if norm_direction.y >= 0.707:
		return "down"
	elif norm_direction.y <= -0.707:
		return "up"
	elif norm_direction.x <= -0.707:
		return "left"
	elif norm_direction.x >= 0.707:
		return "right"
	return "down"


func _input(event):
	if event.is_action_pressed("attack"):
		# Check if player can attack
		var now = OS.get_ticks_msec()
		if now >= next_attack_time:
			# What's the target?
			var target = $RayCast2D.get_collider()
			# The attack animation is always available except when the target is an NPC
			if!(target != null and target.is_in_group("NPCs")):
				# Play attack animation
				attack_playing = true
				var animation = get_direction_for_animation(last_direction) + "_attack"
				$AnimatedSprite.play(animation)
				# Play attack sound
				$SoundAttack.play()
				# Add cooldown time to current time
				next_attack_time = now + attack_cooldown_time
	if event.is_action_pressed("ui_accept"):
		var target = $RayCast2D.get_collider()
		if target != null:
			if target.is_in_group("NPCs"):
					# Talk to NPC
					target.talk()
					return
			if target.name == "Bed":
				# Sleep
				emit_signal("player_sleep", self)
				yield(get_tree().create_timer(1), "timeout")
				health = health_max
				mana = mana_max
				emit_signal("player_stats_changed", self)
				return
	# DEBUG
	if event.is_action_pressed("debug2"):
		print(ItemHandler.temporary_items)


func _on_AnimatedSprite_animation_finished():
	attack_playing = false


# If something is not connected with GUI and can't call the signal
func force_reloading_GUI():
	emit_signal("player_stats_changed", self)


func add_coins(value):
	coins += value
	emit_signal("player_stats_changed", self)
	
func add_reputation(value):
	reputation += value
	emit_signal("player_stats_changed", self)


func add_xp(value):
	experience += value
	# Has the player reached the next level?
	if experience >= xp_next_level:
		level += 1
		xp_next_level *= 2
		emit_signal("player_level_up")
	emit_signal("player_stats_changed", self)


func add_potion(type):
	if type == Potion.HEALTH:
		ItemHandler.add_to_all_items_dictionary("Health Potion", 1, 0, 0)
		ItemHandler.add_to_temporary_items_dictionary("Health Potion", 1, 0, 0)
		health_potions = health_potions + 1
	else:
		ItemHandler.add_to_all_items_dictionary("Mana Potion", 1, 16, 0)
		ItemHandler.add_to_temporary_items_dictionary("Mana Potion", 1, 16, 0)
		mana_potions = mana_potions + 1
	emit_signal("player_stats_changed", self)


func add_questitem_in_GUI(x,y,text):
	# TODO per ora non so come farlo meglio, forse rendere il player.gd script global?
	emit_signal("player_additem_to_gui", x, y, text)


func to_dictionary():
	return {
		"position" : [position.x, position.y],
		"health" : health,
		"health_max" : health_max,
		"mana" : mana,
		"mana_max" : mana_max,
		"experience" : experience,
		"xp_next_level" : xp_next_level,
		"level" : level,
		"health_potions" : health_potions,
		"mana_potions" : mana_potions
	}


func from_dictionary(data):
	position = Vector2(data.position[0], data.position[1])
	health = data.health
	health_max = data.health_max
	mana = data.mana
	mana_max = data.mana_max
	experience = data.experience
	xp_next_level = data.xp_next_level
	level = data.level
	health_potions = data.health_potions
	mana_potions = data.mana_potions
