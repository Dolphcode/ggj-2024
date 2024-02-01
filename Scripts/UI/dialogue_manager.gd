extends Control

# This is going to be kind of jank but it gets the job done

@export_category("References")
@export var dialogue_text_label: Label
@export var dialogue_speaker_label: Label
@export var speaker0: TextureRect
@export var speaker1: TextureRect
@export var start_animation_player: AnimationPlayer


@export var dialogue_contents_path: String

var dialogue: Array[String]
var dialogue_complete: bool = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var file = FileAccess.open(dialogue_contents_path, FileAccess.READ)
	var content = file.get_as_text()
		
	var str_out = ""
	for str in content.split("-"):
		for sym in str.split(""):
			if (sym.is_valid_int() || sym.is_valid_identifier() || sym == " " || "?!.,'".contains(sym)):
				str_out += sym
		dialogue.append(str_out)
		str_out = ""
	run_dialogue()

func _process(delta):
	if (!dialogue_complete):
		if (Input.is_action_just_pressed("dialog")):
			run_dialogue()
		elif (Input.is_action_just_pressed("skip_dialog")):
			finish_dialog()
			return

func run_dialogue():
	if (dialogue.size() <= 0):
		finish_dialog()
		return
	
	var line = dialogue[0]
	if (line.begins_with('0')):
		speaker0.visible = true
		speaker1.visible = false
		dialogue_speaker_label.text = "Host"
	else:
		speaker0.visible = false
		speaker1.visible = true
		dialogue_speaker_label.text = "Player"
		
	line = dialogue[0].substr(1)
	dialogue.remove_at(0)
	
	dialogue_text_label.text = line
	
func finish_dialog():
	dialogue_complete = true
	visible = false
	start_animation_player.play("countdown")
		
	
