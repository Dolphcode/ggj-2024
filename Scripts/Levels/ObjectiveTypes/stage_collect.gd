class_name StageCollect
extends StageBase

@export_category("Hazard Config")
@export var spawns: Array[String]

@export_category("Collection Config")
@export var collectibles: Array[String]

var enemies: Array[ParentEnemy]
var interacts: Array[BaseInteractable]

func start_stage(stageplatform, player):
	# Call superclass to set up grid reference
	super.start_stage(stageplatform, player)
	
	var enemypos: Array[Vector2i] = []
	var collectiblepos: Array[Vector2i] = []
	for y in range(0, grid_info_arr.size()):
		for x in range(0, grid_info_arr[0].size()):
			if grid_info_arr[y][x] == 'x':
				collectiblepos.append(Vector2i(x,y))
			elif grid_info_arr[y][x] == 'y':
				enemypos.append(Vector2i(x,y))
				
	for spawn in spawns:
		var enemy = load(spawn).instantiate()
		stageplatform.add_child(enemy)
		var randidx = randi_range(0, enemypos.size() - 1)
		var randpos = enemypos[randidx]
		enemypos.remove_at(randidx)
		enemy.position = Vector3(randpos.x, randpos.y, 1)
		enemies.append(enemy)
		
	for collectible in collectibles:
		var interact = load(collectible).instantiate()
		stageplatform.add_child(interact)
		var randidx = randi_range(0, collectiblepos.size() - 1)
		var randpos = collectiblepos[randidx]
		collectiblepos.remove_at(randidx)
		interact.position = Vector3(randpos.x, randpos.y, 1)
		interacts.append(interact)
		interact.player_interact.connect(_on_interact)
		
func end_stage():
	var i = 0
	while enemies.size() > 0:
		var enemy = enemies[0]
		enemies.remove_at(0)
		if typeof(enemy) != TYPE_NIL && is_instance_valid(enemy):
			enemy.queue_free()
	super.end_stage()

func _on_interact(interact):
	for i in range(0, interacts.size()):
		if (interacts[i] == interact):
			interacts.remove_at(i)
			break
			
	if (interacts.size() <= 0):
		end_stage()

