extends AudioStreamPlayer

# Called when the node enters the scene tree for the first time.
func _ready():
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass



func _on_player_walking():
	if !is_playing():
		play()

func _on_player_stop_walking():
	stop()
