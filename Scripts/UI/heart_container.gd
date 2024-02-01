class_name HeartContainer
extends HBoxContainer

func _on_player_hurt(health):
	if health == 2:
		$Heart3.visible = false
	elif health == 1:
		$Heart2.visible = false
	else:
		$Heart1.visible = false
