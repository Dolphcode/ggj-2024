extends Node

# This code is not ideal but it'll work for now
@export_category("Config")
@export var level_one : Array[StageBase]
@export var level_two : Array[StageBase]
@export var level_three: Array[StageBase]
@export var time: float = 60.0

@export_category("References")
@export var timer: Timer
@export var stage_platform: StagePlatform
@export var timer_label: Label
var stage: StageBase

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = time
	stage = pick_stage()
	stage.stage_complete.connect(_on_stage_end)
	stage.start_stage(stage_platform)
	timer.start()
	
func _process(delta):
	timer_label.text = str(ceil(timer.time_left))
	

func _on_stage_end():
	stage.stage_complete.disconnect(_on_stage_end)
	timer.paused = true
	stage = pick_stage()
	stage.stage_complete.connect(_on_stage_end)
	stage.start_stage(stage_platform)
	timer.paused = false

func pick_stage():
	#var stage_picks = level_one if (timer.time_left < time / 3.0) else (level_two if (timer.time_left < time * 2.0 / 3.0) else level_three)
	var stage_picks = level_one
	return stage_picks.pick_random()
