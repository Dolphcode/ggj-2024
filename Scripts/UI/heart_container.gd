class_name HeartContainer
extends HBoxContainer


# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass


func _on_player_hurt(health):
	if health == 2:
		$Heart3.visible = false
	elif health == 1:
		$Heart2.visible = false
	else:
		$Heart1.visible = false
