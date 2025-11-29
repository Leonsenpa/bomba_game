extends CharacterBody2D


const SPEED = 100.0
const JUMP_VELOCITY = -200.0
var current_direction = 0
var bombs_deployed = [null,null]
@onready var bomb_scene = load("res://Scenes/bomb.tscn")
@onready var animated_sprite = $AnimatedSprite2D


func _physics_process(delta):
	# On met la gravité
	if not is_on_floor():
		velocity += get_gravity() * delta
		
	# On récupère les instructions de direction et on gère le mouvement
	else :
		var direction = Input.get_axis("q", "d")
		if direction > 0:
			velocity.x = direction * SPEED
			animated_sprite.play("Run")
			animated_sprite.flip_h = false
		elif direction < 0:
			velocity.x = direction * SPEED
			animated_sprite.play("Run")
			animated_sprite.flip_h = true
		else:
			velocity.x = move_toward(velocity.x, 0, SPEED)
			if velocity.x == 0:
				animated_sprite.play("Idle")
	# On gère le saut
	if Input.is_action_just_pressed("ui_accept") and is_on_floor():
		velocity.y = JUMP_VELOCITY
		animated_sprite.play("Jump_idle")
	
	if Input.is_action_just_pressed("ui_down"):
		if bombs_deployed[0] == null:
			spawn_bomb(Vector2(0, 5), 0)
			global_position += Vector2(0, -16)
		elif bombs_deployed[1] == null:
			spawn_bomb(Vector2(0, 5), 1)
			global_position += Vector2(0, -16)
		else:
			pass
	
	if Input.is_action_just_pressed("ui_left"):
		if bombs_deployed[0] == null:
			spawn_bomb(Vector2(-16, 0), 0)
		elif bombs_deployed[1] == null:
			spawn_bomb(Vector2(-16, 0), 1)
		else:
			pass
			
	if Input.is_action_just_pressed("ui_right"):
		if bombs_deployed[0] == null:
			spawn_bomb(Vector2(16, 0), 0)
		elif bombs_deployed[1] == null:
			spawn_bomb(Vector2(16, 0), 1)
		else:
			pass
	
	if Input.is_action_just_pressed("ui_up"):
		if bombs_deployed[0] == null:
			spawn_bomb(Vector2(0, -16), 0)
		elif bombs_deployed[1] == null:
			spawn_bomb(Vector2(0, -16), 1)
		else:
			pass
	
	if Input.is_action_just_pressed("1") and bombs_deployed[0] != null:
		explode_bomb(bombs_deployed[0], 0)
	
	if Input.is_action_just_pressed("2") and bombs_deployed[1] != null:
		explode_bomb(bombs_deployed[1], 1)
		
	move_and_slide()


func spawn_bomb(bomb_offset, place):
	var bomb = bomb_scene.instantiate()
	bombs_deployed[place] = bomb
	bomb.position = global_position + bomb_offset
	get_tree().current_scene.add_child(bomb)
	
func explode_bomb(bomb, place):
	var differential = global_position - bombs_deployed[place].position
	var theta = atan(abs(differential.y/differential.x))
	var dir = [0, 0]
	
	if differential.x < 0:
		dir[0] = -1
		if differential.x < -16:
			differential.x += 16
		else:
			differential.x = 0
	elif differential.x > 0:
		dir[0] = 1
		if differential.x > 16:
			differential.x -= 16
		else:
			differential.x = 0
	
	if differential.y < 0:
		dir[1] = -1
		if differential.y < -16:
			differential.y += 16
		else:
			differential.y = 0
	elif differential.y > 0:
		dir[1] = 1
		if differential.y > 16:
			differential.y -= 16
		else:
			differential.y = 0
			
	var hypothenus = sqrt(differential.x**2 + differential.y**2)
	if hypothenus < 1:
		hypothenus = 1
	
	if hypothenus < 60:
		#velocity = Vector2(dir[0]*cos(theta)*(700-5*hypothenus), dir[1]*sin(theta)*(400-5*hypothenus))	
		velocity = Vector2(dir[0]*cos(theta)*(1000*exp(-hypothenus/25)), dir[1]*sin(theta)*(600*exp(-hypothenus/25)))
	get_tree().current_scene.remove_child(bomb)
	bombs_deployed[place] = null
	
func remove_bomb():
	if bombs_deployed[0] != null:
		get_tree().current_scene.remove_child(bombs_deployed[0])
		bombs_deployed[0] = null
	if bombs_deployed[1] != null:
		get_tree().current_scene.remove_child(bombs_deployed[1])
		bombs_deployed[1] = null
