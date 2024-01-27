@tool
class_name GenerateStage
extends EditorScript

const StagePlatClass = preload("res://Scripts/Environment/stage_platform.gd")

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	for platform in get_stage_platforms(get_scene()):
		var plat := platform as StagePlatform
		platform.generate_platforms()
		
	pass

func get_stage_platforms(in_node, platforms = []):
	if in_node is StagePlatClass:
		platforms.append(in_node)
		
		
	for child in in_node.get_children():
		platforms.append_array(get_stage_platforms(child))
		
	return platforms
