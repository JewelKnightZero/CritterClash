extends Camera3D
@onready var playerManager: Node3D = %PlayerManager
var maxDistance:float = 0
var maxXDistance:float = 0
var maxYDistance:float = 0
const startingDistance: float = 10
@export var maxCamDistance:float = 30
@export var minCamDistance:float = 5
const camSpeed:float = 100

func _physics_process(delta: float) -> void:
	#Move the camera to show all players.
	#First we find the max distance to a player
	maxXDistance = minCamDistance #Reset each frame to minimum distance
	maxYDistance = minCamDistance
	for child: CharacterBody3D in playerManager.get_children(): # Loop through players to find the furthest distances
		if maxXDistance < abs(child.global_position.x):
			maxXDistance = abs(child.global_position.x)
		if maxYDistance < abs(child.global_position.y):
			maxYDistance = abs(child.global_position.y)
	maxDistance = maxXDistance if maxXDistance > maxYDistance else maxYDistance #Reads surprisingly well.returns the bigger distance
	if maxDistance > maxCamDistance:
		maxDistance = maxCamDistance
	
	position.z = move_toward(position.z, maxDistance, delta * camSpeed)
