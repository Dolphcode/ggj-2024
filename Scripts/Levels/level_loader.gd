extends Node

# This code is not ideal but it'll work for now
@export_category("Config")
@export var level_one : Array[StageBase]
@export var level_two : Array[StageBase]
@export var level_three: Array[StageBase]
@export var time: float = 30.0

@export_category("References")
@export var timer: Timer
@export var stage_platform: StagePlatform
@export var timer_label: Label
@export var curtain_anim: AnimationPlayer
@export var player: Player

@export_category("Dialog")
@export var dialog_anim: AnimationPlayer
@export var dialog_text: Label
@export var dialog_name: Label
@export var dialog_texture: TextureRect
var stage: StageBase

# Called when the node enters the scene tree for the first time.
func _ready():
	timer.wait_time = time
	stage = pick_stage()
	stage.stage_complete.connect(_on_stage_end)
	stage.start_stage(stage_platform, player)
	timer.start()
	show_dialog()
	
func _process(delta):
	timer_label.text = str(ceil(timer.time_left))
	
	if timer.is_stopped():
		get_tree().change_scene_to_file("res://win.tscn")

func _on_stage_end():
	get_tree().paused = true
	curtain_anim.play("Close")

func pick_stage():
	#var stage_picks = level_one if (timer.time_left < time / 3.0) else (level_two if (timer.time_left < time * 2.0 / 3.0) else level_three)
	var stage_picks = level_one
	return stage_picks.pick_random()


func _on_curtain_animation_animation_finished(anim_name):
	if (anim_name == "Close"):
		stage.stage_complete.disconnect(_on_stage_end)
		timer.paused = true
		stage = pick_stage()
		stage.stage_complete.connect(_on_stage_end)
		stage.start_stage(stage_platform, player)
		timer.paused = false
		get_tree().paused = false
		curtain_anim.play("Open")
		show_dialog()

func show_dialog():
	dialog_text.text = stage.event_dialog
	dialog_name.text = stage.event_character
	dialog_texture.texture = stage.icon
	dialog_anim.play("ShowDialog")
