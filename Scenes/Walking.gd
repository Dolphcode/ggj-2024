extends AudioStreamPlayer

func _on_player_walking():
	if !is_playing():
		play()

func _on_player_stop_walking():
	stop()
