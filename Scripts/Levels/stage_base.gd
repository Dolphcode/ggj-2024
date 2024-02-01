class_name StageBase
extends Node

signal stage_complete

# Export Variables
@export_category("Data")
@export var grid_info: String = "res://Assets/Grid Info/sample.txt" # This is the path to the level data text file
@export var event_name: String = "Base Name" # This is the name of the event
@export_multiline var event_objectives_text = "Objectives go here" # This is the list of objectives to be shown to the user
@export var event_icon: String = "res://Assets/Sprites/Icons/tv_head.png" # This is the path to the character icon for the dialogue that appears for this event
@export var event_character: String = "TV Guy" # This is the name of the character speaking when this event comes up
@export_multiline var event_dialog: String = "Eventing time!" # This is the text that the character speaks when this event comes up

# State
var grid_info_arr = []
var level_loader
var is_loaded = false
var icon : Texture

func _ready():
	var image = load(event_icon).get_image()
	icon = ImageTexture.create_from_image(image)
	level_loader = get_parent()

# Please call the super method to set up grid_info_arr
func start_stage(stageplatform, player):
	if (!is_loaded):
		var file = FileAccess.open(grid_info, FileAccess.READ)
		var content = file.get_as_text()
		
		var str_arr = []
		for line in content.split("-"):
			var row = []
			grid_info_arr.append([])
			for sym in line.split(""):
				if (sym.is_valid_int() || sym.is_valid_identifier()):
					row.append(sym)
			str_arr.append(row)
		
		for i in range(0, str_arr.size()):
			for j in range(0, str_arr[0].size()):
				grid_info_arr[str_arr.size() - i - 1].append(str_arr[i][j])
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
				
			if grid_info_arr[i][j] == "p":
				player.position = Vector3(j, i, player.position.z)

func end_stage():
	level_loader._on_stage_end()
