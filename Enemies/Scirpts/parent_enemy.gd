class_name ParentEnemy
extends CharacterBody3D

const SPEED = 3.0
const JUMP_VELOCITY = 13.0

@onready var detect_platform = $LedgeDetection
@onready var detect_Jump = $JumpDetection
@onready var detect_Wall = $WallDetection
@onready var detect_leap = $LeapDetection
var rand

# For testing if a player has bopped this guy
const PlayerClass = preload("res://Scripts/player.gd")

signal on_enemy_death(enemy)

# direction
var input_dir = Vector3(1,0,0)

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

var turn = false
var jump = false

# Called when the node enters the scene tree for the first time.
func _ready():
	rand = randi_range(0, 9)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	# detect if enemy is on the edge
	if !detect_platform.is_colliding() and is_on_floor():
		# if there is a block to jump to
		if detect_leap.is_colliding():
			jump = true
		elif rand <= 4:
			turn = true
		else:
			turn = false
	else:
		turn = false
	
	
	

func _physics_process(delta):
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta

	# Handle jump.
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
	
	if jump:
		velocity.y = JUMP_VELOCITY
		jump = false
		velocity.x = direction.x * SPEED
	move_and_slide()
	
func _on_wall_detection_body_entered(body):
	print("Wall!")
	if detect_Jump.is_colliding():
		scale.x = scale.x * -1
	else:
		jump = true


func _on_head_body_entered(body):
	print("Whoa")
	if body is PlayerClass:
		body.jump_force()
		emit_signal("on_enemy_death", self)
		queue_free() # Temporary


