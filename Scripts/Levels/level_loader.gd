class_name LevelLoader
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
@export var progress_bar: TextureProgressBar
@export var curtain_anim: AnimationPlayer
@export var player: Player
@export var ui_layer: CanvasLayer
@export var stage_music: AudioStreamPlayer
@export var transition_anim_player: AnimationPlayer

@export_category("Sound Files")
@export var default_music_path: String

@export_category("Dialog")
@export var dialog_anim: AnimationPlayer
@export var dialog_text: Label
@export var dialog_name: Label
@export var objective_list: Label
@export var dialog_texture: TextureRect
var stage: StageBase

# Audio Files
var default_music
var game_over = false

# Called when the node enters the scene tree for the first time.
func _ready():
	default_music = load(default_music_path)
	
	ScoreKeeper.score = 0
	timer.wait_time = time
	progress_bar.max_value = time
	stage = pick_stage()
	stage.stage_complete.connect(_on_stage_end)
	LevelTransitionChecker.transitioning = true
	
func _process(_delta):
	timer_label.text = str(ceil(timer.time_left))
	var color: float = timer.time_left / time
	progress_bar.tint_progress = Color(1 - color, color, 0)
	progress_bar.value = timer.time_left

func _on_stage_end():
	LevelTransitionChecker.transitioning = true
	ScoreKeeper.score += 1
	curtain_anim.play("Close")

func pick_stage():
	var stage_picks = level_one if (timer.time_left < time / 3.0) else (level_two if (timer.time_left < time * 2.0 / 3.0) else level_three)
	#var stage_picks = level_one
	return stage_picks.pick_random()


func _on_curtain_animation_animation_finished(anim_name):
	if (anim_name == "Close"):
		stage.stage_complete.disconnect(_on_stage_end)
		timer.paused = true
		stage = pick_stage()
		stage.stage_complete.connect(_on_stage_end)
		stage.start_stage(stage_platform, player)
		timer.paused = false
		LevelTransitionChecker.transitioning = false
		curtain_anim.play("Open")
		show_dialog()

func show_dialog():
	dialog_text.text = stage.event_dialog
	dialog_name.text = stage.event_character
	dialog_texture.texture = stage.icon
	objective_list.text = stage.event_objectives_text
	dialog_anim.play("ShowDialog")


func _on_start_animation_player_animation_finished(anim_name):
	if (anim_name == "countdown"):
		LevelTransitionChecker.transitioning = false
		stage_music.stream = default_music
		stage_music.play()
		curtain_anim.play("Open")
		stage.start_stage(stage_platform, player)
		timer.start()
		show_dialog()
		ui_layer.visible = true
	elif (anim_name == "game_end"):
		if (game_over):
			get_tree().change_scene_to_file("res://game_over.tscn")
		else:
			get_tree().change_scene_to_file("res://win.tscn")

func _on_timer_timeout():
	end_game(false)
	
func end_game(is_game_over):
	game_over = is_game_over
	LevelTransitionChecker.transitioning = true
	timer.stop()
	stage_music.stop()
	transition_anim_player.play("game_end")
	
