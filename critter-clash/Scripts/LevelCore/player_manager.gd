extends Node3D

#On pressing the join button create a character at the specified coordinates
var playerPrefab = preload("res://Scenes/Characters/player.tscn")
var playerIDs = {}
var containsPlayer:bool = false

func _input(event: InputEvent) -> void:
	for id in playerIDs:
		if id == event.device:
				containsPlayer = true
		if event.is_action_pressed("Jump"):
			playerIDs.get(id).jump = true

		if event.is_action("MoveLeft") ||  event.is_action("MoveRight") ||  event.is_action("MoveDown") ||  event.is_action("MoveUp"):
			playerIDs.get(id).inputVector = Vector2.ZERO
			playerIDs.get(id).inputVector.x += event.get_action_strength("MoveRight")
			playerIDs.get(id).inputVector.x -= event.get_action_strength("MoveLeft")
			playerIDs.get(id).inputVector.y += event.get_action_strength("MoveUp")
			playerIDs.get(id).inputVector.y -= event.get_action_strength("MoveDown")
		
		if event.is_action_pressed("Attack1"):
			playerIDs.get(id).Attack()
		
	if event.is_action_pressed("Join"):
		if containsPlayer != true:
			print(event.device)
			var newPlayer = playerPrefab.instantiate()
			newPlayer.playerID = event.device
			add_child(newPlayer)
			newPlayer.global_position = newPlayer.startPosition
			playerIDs.get_or_add(event.device, newPlayer)
	
