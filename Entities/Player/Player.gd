extends KinematicBody2D

export var speed = 75
var last_direction = Vector2(0,1)
var attack_playing = false

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
	if not attack_playing:
		player_animations_handler(direction)


func player_animations_handler(direction: Vector2):
	if direction != Vector2.ZERO:
		#Analog stick bounce problem
		last_direction = 0.5 * last_direction + 0.5 * direction
		var animation = get_animation_direction(last_direction) + "_walk"
		#Joypad FPS adjusting
		$AnimatedSprite.frames.set_animation_speed(animation, 2 + 8 * direction.length())
		$AnimatedSprite.play(animation)
	else:
		var animation = get_animation_direction(last_direction) + "_idle"
		$AnimatedSprite.play(animation)


func get_animation_direction(direction: Vector2):
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
		attack_playing = true
		var animation = get_animation_direction(last_direction) + "_attack"
		$AnimatedSprite.play(animation)


func _on_AnimatedSprite_animation_finished():
	attack_playing = false
