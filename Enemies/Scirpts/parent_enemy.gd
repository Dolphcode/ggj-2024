extends CharacterBody3D

const SPEED = 2.0
const JUMP_VELOCITY = 4.5

@onready var detect_platform = $LedgeDetection
@onready var detect_Jump = $JumpDetection
@onready var detect_Wall = $WallDetection

# direction
var input_dir = Vector3(1,0,0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var turn = false
var jump = false

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	if !detect_platform.is_colliding():
		turn = true
	else:
		turn = false
	
	
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
	#if Input.is_action_just_pressed("ui_accept") and is_on_floor():
	#	velocity.y = JUMP_VELOCITY

	# Get the input direction and handle the movement/deceleration.
	# Direction
	
	# Handle turning
	if turn:
		scale.x = scale.x * -1
	
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()
	
func _on_wall_detection_body_entered(body):
	print("Wall!")
	scale.x = scale.x * -1
