extends CharacterBody3D

#Everything for the player characters

@onready var animationTree: AnimationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var groundRayCast: RayCast3D = $RayCast3D


enum states {
	MOVE,
	ROLL,
	ATTACK
}

var state: states = states.MOVE
var rollVector: Vector3 = Vector3.RIGHT

@export var speed: float = 100
@export var maxSpeed: float = 20
@export var friction: float = 50
@export var rollSpeed: float = 1.5
@export var jumpSpeed: float = 3000
@export var gravity: float = 200
@export var jumps: int = 1
@export var maxJumps: int = 1

func _physics_process(delta: float) -> void:
	
	match state:
		states.MOVE:
			MoveState(delta)
		states.ROLL:
			RollState()
		states.ATTACK:
			AttackState()

func MoveState(delta:float):
	var inputVector = Input.get_vector("MoveLeft", "MoveRight", "MoveUp", "MoveDown")
	inputVector = inputVector.normalized()
	
	if inputVector != Vector2.ZERO:
	#	rollVector = inputVector
		#animationTree.set("parameters/Idle/blend_position", inputVector)
		#animationTree.set("parameters/Run/blend_position", inputVector)
		#animationTree.set("parameters/Attack/blend_position", inputVector)
		#animationTree.set("parameters/Roll/blend_position", inputVector)
		#animationState.travel("Run")
		
		velocity += Vector3(inputVector.x, inputVector.y, 0) * speed * delta
		velocity.x = clamp(velocity.x, -maxSpeed, maxSpeed)
	else:
		animationState.travel("Idle")
		
	if Input.is_action_just_pressed("Jump") && jumps > 0 :
			velocity.y += delta * jumpSpeed
			jumps -= 1
	
	if groundRayCast.is_colliding():
		velocity = velocity.move_toward(Vector3(0, velocity.y, 0), delta * friction)
		jumps = maxJumps
	
	velocity.y -= gravity * delta
	
	move_and_slide()
	#if Input.is_action_just_pressed("Attack"):
	#	state = states.ATTACK
	#elif Input.is_action_just_pressed("Roll"):
	#	state = states.ROLL
	
func AttackState():
	animationState.travel("Attack")
	velocity = Vector3.ZERO
	
func RollState():
	animationState.travel("Roll")
	velocity = rollVector * maxSpeed * rollSpeed
	move_and_slide()
	
func AnimationFinished():
	state = states.MOVE
