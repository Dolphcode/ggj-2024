class_name StageBase
extends Node

signal stage_complete

@export_category("Data")
@export var grid_info: String
@export var event_name: String = "Base Name"
@export var event_dialog: String = "Eventing time!"
@export var event_icon: String = "Oop"
@export var event_character: String = "TVHead"

var grid_info_arr = []
var level_loader

var is_loaded = false

func _ready():
	level_loader = get_parent()

# Please call the super method to set up grid_info_arr
func start_stage(stageplatform):
	if (!is_loaded):
		var file = FileAccess.open(grid_info, FileAccess.READ)
		var content = file.get_as_text()
		
		var str_arr = []
		for str in content.split("-"):
			var row = []
			grid_info_arr.append([])
			for sym in str.split(""):
				if (sym.is_valid_int() || sym.is_valid_identifier()):
					row.append(sym)
			str_arr.append(row)
		
		for i in range(0, str_arr.size()):
			var str = ""
			for j in range(0, str_arr[0].size()):
				grid_info_arr[str_arr.size() - i - 1].append(str_arr[i][j])
				str += str_arr[i][j]
				if str_arr[i][j] == "1":
					stageplatform.toggle_tile(1, j, str_arr.size() - i - 1)
				else:
					stageplatform.toggle_tile(0, j, str_arr.size() - i - 1)
	is_loaded = true
	
	for i in range(0, grid_info_arr.size()):
		for j in range(0, grid_info_arr[0].size()):
			if grid_info_arr[i][j] == "1":
				stageplatform.toggle_tile(1, j, grid_info_arr.size() - 1)
			else:
				stageplatform.toggle_tile(0, j, grid_info_arr.size() - 1)

func end_stage():
	level_loader._on_stage_end()
