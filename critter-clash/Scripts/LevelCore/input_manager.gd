extends Node3D

var playerPrefab = preload("res://Scenes/Characters/player.tscn")

@onready var playerManager = %PlayerManager
var playerDict= {}

func joinPlayer(player:int):
	var newPlayer = playerPrefab.instantiate()
	add_child(newPlayer)
	newPlayer.global_position = newPlayer.startPosition
	playerDict.get_or_add(player, newPlayer)

func _process(delta: float) -> void:
	for id in playerDict:
		var device = playerManager.get_player_device(id)
		playerDict.get(id).inputVector = MultiplayerInput.get_vector(device, "MoveLeft", "MoveRight", "MoveUp", "MoveDown")
		if MultiplayerInput.is_action_just_pressed(device, "Jump"):
			playerDict.get(id).jump = true
		if MultiplayerInput.is_action_just_pressed(device, "Attack1"):
			playerDict.get(id).Attack()
		if MultiplayerInput.is_action_just_pressed(device, "Attack2"):
			playerDict.get(id).Attack2()


func _on_player_manager_player_joined(player: Variant) -> void:
	print(player)
	joinPlayer(player)
