class_name BaseInteractable
extends Node3D

# For testing if a player has walked into this guy
const PlayerClass = preload("res://Scripts/player.gd")

signal player_interact(interact)

func _on_interactable_body_entered(body):
	# I genuinely don't know why these are getting destroyed as they spawn even if the player is being moved before they are spawned, this is the best solution I could come up with
	if body is PlayerClass && (body.position - position).length() <= 2: 
		emit_signal("player_interact", self)
		queue_free()
