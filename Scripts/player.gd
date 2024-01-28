class_name Player
extends CharacterBody3D

@export var health = 3
@export var SPEED = 5.0
@export var JUMP_VELOCITY = 18.0
@onready var sprite3d = $Sprite3D

signal hurt

# Get the gravity from the project settings to be synced with RigidBody nodes.
var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

func _process(_delta):
	if health == 0:
		get_tree().change_scene_to_file("res://game_over.tscn")
	if !$HurtTimer.is_stopped():
		hurt.emit(health)
		$HurtBox/CollisionShape3D.disabled = true
	else:
		$HurtBox/CollisionShape3D.disabled = false
		sprite3d.modulate = Color(1,1,1,1)
		


func _physics_process(delta):
	
	position.z = 2
	
	# Add the gravity.
	if not is_on_floor():
		velocity.y -= gravity * delta
	
	# Handle jump.
	if Input.is_action_just_pressed("jump") and is_on_floor():
		jump_force()

	# Get the input direction and handle the movement/deceleration.
	# As good practice, you should replace UI actions with custom gameplay actions.
	var input_dir = Input.get_vector("left", "right", "ui_up", "ui_down")
	var direction = (transform.basis * Vector3(input_dir.x, 0, input_dir.y)).normalized()
	if direction:
		velocity.x = direction.x * SPEED
	else:
		velocity.x = move_toward(velocity.x, 0, SPEED)

	move_and_slide()

func _on_hurt_box_area_entered(area):
	if area.is_in_group("Enemy"):
		health -= 1
		sprite3d.modulate = Color(1,0,0,1)
		print(health)
		$HurtTimer.start()
		
func jump_force():
	velocity.y = JUMP_VELOCITY
