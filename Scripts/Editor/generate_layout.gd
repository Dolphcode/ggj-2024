@tool
class_name GenerateLayout
extends EditorScript

const LayoutMapClass = preload("res://Scripts/Editor/layout_tilemap.gd")

# Called when the script is executed (using File -> Run in Script Editor).
func _run():
	var tilemap: LayoutTileMap = get_tilemap(get_scene())
	
	var output = ""
	for y in range(0, tilemap.dims.y):
		for x in range(0, tilemap.dims.x):
			output += tilemap.get_cell_tile_data(0, Vector2i(x, y)).get_custom_data("Tile Data")
		output += "-\n" if y < tilemap.dims.y - 1 else ""
	
	var filepath = tilemap.export_path + tilemap.export_filename + ".txt"
	var i = 0
	while (FileAccess.file_exists(filepath)):
		i += 1
		filepath = tilemap.export_path + tilemap.export_filename + "(" + str(i) + ").txt"
	var file = FileAccess.open(filepath, FileAccess.WRITE)
	file.store_string(output)
	file.close()
			

# We're assuming there's only one TileMap
func get_tilemap(scene):
	if (scene is LayoutMapClass):
		return scene
		
	var tilemap
	for child in scene.get_children():
		tilemap = get_tilemap(child)
		if tilemap != null:
			return tilemap
	
