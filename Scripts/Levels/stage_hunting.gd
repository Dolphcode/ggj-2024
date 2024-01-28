class_name StageHunting
extends StageBase

func start_stage(stageplatform):
	# Call superclass to set up grid reference
	super.start_stage(stageplatform)
	
	var file = FileAccess.open(grid_info, FileAccess.READ)
	var content = file.get_as_text()
	
	var str_arr = []
	for str in content.split("-"):
		var row = []
		grid_info_arr.append([])
		for sym in str.split(""):
			row.append(sym)
		str_arr.append(row)
		
	for i in range(0, str_arr.size()):
		for j in range(0, str_arr[0].size()):
			grid_info_arr[str_arr.size() - i - 1].append(str_arr[i][j])
			if str_arr[i][j] == "1":
				stageplatform.toggle_tile(1, j, str_arr.size() - i - 1)
			else:
				stageplatform.toggle_tile(0, j, str_arr.size() - i - 1)
			


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass
