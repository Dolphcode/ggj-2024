@tool
class_name StagePlatform
extends Node3D

@export var dimensions: Vector2i = Vector2i(0, 0)
@export var plat_scale: int = 1
@export var world_size: float = 2.0


# Called when the node enters the scene tree for the first time.
func _ready():
	generate_platforms()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func generate_platforms():
	var tile = load("res://Scenes/Environment/grid_tile.tscn")
	for x in range(0, dimensions.x * plat_scale):
		for y in range(0, dimensions.y * plat_scale):
			var newtile = tile.instantiate()
			print(newtile)
			newtile.position.x = x
			newtile.position.y = y
			add_child(newtile)
	
