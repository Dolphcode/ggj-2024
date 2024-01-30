class_name SimpleProjectile3D
extends CharacterBody3D

var gravity = ProjectSettings.get_setting("physics/3d/default_gravity")

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _physics_process(delta):
	if LevelTransitionChecker.transitioning:
		return
	
	velocity += delta * Vector3(0, -gravity, 0)
	move_and_slide()
	
func lob(target):
	var t_pos = target.global_position
	var pos = global_position
	
	var to_target = Vector2(t_pos.x - pos.x, t_pos.z - pos.z)
	var planar_distance = to_target.length()
	
	var y_distance = t_pos.y - pos.y
	
	var planar_speed = planar_distance * sqrt(gravity / (2.0 * y_distance))
	var y_speed = sqrt(2.0 * y_distance * gravity)
	
	var to_target_velocity = to_target.normalized() * planar_speed
	
	var velocity_vector = Vector3(to_target_velocity.x, y_speed, to_target_velocity.y)
	
	velocity = velocity_vector
	
	
