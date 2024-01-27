@tool
class_name StagePlatform
extends Node3D

enum ScaleMode { HEIGHT, WIDTH }

@export var dimensions: Vector2i = Vector2i(0, 0)
@export var plat_scale: int = 1

var tiles = []


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_platforms()
	if !Engine.is_editor_hint():
		toggle_tile(1, 0, 0)
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func toggle_tile(state, x, y):
	tiles[y][x].position.z = state if (state == 0 || state == 1) else 0

func generate_platforms():
	# Get rid of all exising children to regenerate tiles, this is the easiest approach
	for child in get_children():
		child.queue_free()
	
	var tile = load("res://Scenes/Environment/grid_tile.tscn")
	for x in range(0, dimensions.x * plat_scale):
		var x_set = []
		for y in range(0, dimensions.y * plat_scale):
			var newtile = tile.instantiate()
			newtile.position.x = x
			newtile.position.y = y
			add_child(newtile)
			x_set.append(newtile)
		tiles.append(x_set)
	
