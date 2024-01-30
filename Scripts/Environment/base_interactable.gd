class_name BaseInteractable
extends Node3D

# For testing if a player has walked into this guy
const PlayerClass = preload("res://Scripts/player.gd")

signal player_interact(interact)


func _on_interactable_body_entered(body):
	if body is PlayerClass:
		emit_signal("player_interact", self)
		queue_free()
