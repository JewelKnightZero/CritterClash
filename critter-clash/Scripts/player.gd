extends CharacterBody3D

const speed:float = 300 #The movement speed

func _physics_process(delta: float) -> void:
	if Input.is_action_pressed("ui_right"):
		velocity.x += speed * delta
	elif Input.is_action_pressed("ui_left"):
		velocity.x -= speed * delta
	else:
		velocity.x = move_toward(velocity.x, 0, speed * delta * 2)
	move_and_slide()
	
