extends Node3D

@export var projectile = Resource
@export var player_ref = Player
@export var time_max: float
@export var time_min: float

var projectile_timer

# Called when the node enters the scene tree for the first time.
func _ready():
	projectile_timer = get_child(0) as Timer
	projectile_timer.wait_time = randf_range(time_min, time_max)
	projectile_timer.start()

func _process(delta):
	if LevelTransitionChecker.transitioning:
		projectile_timer.paused = true
	else:
		projectile_timer.paused = false

func _on_projectile_lob_timer_timeout():
	projectile_timer.stop()
	projectile_timer.wait_time = randf_range(time_min, time_max)
	projectile_timer.start()
	if (abs(player_ref.global_position.y - global_position.y) > 1.0):
		var proj = projectile.instantiate()
		get_tree().root.get_node("Game").add_child(proj)
		proj.position = global_position
		proj.lob(player_ref)
