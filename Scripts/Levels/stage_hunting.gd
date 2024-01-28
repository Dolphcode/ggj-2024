class_name StageHunting
extends StageBase

@export_category("Hunting Config")
@export var spawns: Array[String]
@export var target_idx: Array[int]

var enemies: Array[ParentEnemy]
var targets: Array[ParentEnemy]


func start_stage(stageplatform):
	# Call superclass to set up grid reference
	super.start_stage(stageplatform)
	
	var positions: Array[Vector2i] = []
	for y in range(0, grid_info_arr.size()):
		for x in range(0, grid_info_arr[0].size()):
			if grid_info_arr[y][x] == 'x':
				positions.append(Vector2i(x,y))
	
	for spawn in spawns:
		var enemy = load(spawn).instantiate()
		stageplatform.add_child(enemy)
		var randidx = randi_range(0, positions.size() - 1)
		var randpos = positions[randidx]
		positions.remove_at(randidx)
		enemy.position = Vector3(randpos.x, randpos.y, 1)
		
		enemies.append(enemy)
	
	for idx in target_idx:
		targets.append(enemies[idx])
		enemies[idx].on_enemy_death.connect(_on_target_death)
			

func end_stage():
	var i = 0
	while enemies.size() > 0:
		var enemy = enemies[0]
		enemies.remove_at(0)
		if typeof(enemy) != TYPE_NIL && is_instance_valid(enemy):
			enemy.queue_free()
	super.end_stage()

func _on_target_death(enemy):
	for i in range(0, targets.size()):
		if (targets[i] == enemy):
			targets.remove_at(i)
			break
			
	if (targets.size() <= 0):
		end_stage()
