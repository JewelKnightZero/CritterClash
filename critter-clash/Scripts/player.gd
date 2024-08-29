extends CharacterBody3D

@onready var animationTree: AnimationTree = $AnimationTree
@onready var animationState = animationTree.get("parameters/playback")
@onready var sprite3d: Sprite3D = $Sprite3D


enum states {
	MOVE,
	ROLL,
	ATTACK
}

var state: states = states.MOVE
var rollVector: Vector3 = Vector3.RIGHT

const speed: float = 100
const maxSpeed: float = 60
const friction: float = 800
const rollSpeed: float = 1.5
const jumpSpeed: float = 3000
const gravity: float = 200

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
		sprite3d.flip_h = true if inputVector.x < 0 else false
		
		velocity += Vector3(inputVector.x, inputVector.y, 0) * speed * delta
	else:
		animationState.travel("Idle")
		velocity = velocity.move_toward(Vector3(0, velocity.y, 0), friction * delta)
		
	if Input.is_action_just_pressed("Jump") :
			velocity.y += delta * jumpSpeed
	
	velocity.y -= gravity * delta
	velocity = velocity.limit_length(maxSpeed)
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
