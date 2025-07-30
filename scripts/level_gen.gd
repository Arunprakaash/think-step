extends Node2D

# Drag your TileMap node here in the editor or get it via $TileMap
@export var tile_map: TileMap

# Mapping from tile name (from JSON) to atlas coordinates in your TileSet (assuming a single row, starting at (0,0))
var tile_name_to_atlas_coords = {
	"Ground": Vector2i(0, 0),
	"Spike": Vector2i(1, 0),
	"Wall": Vector2i(2, 0),
	"Movable Block": Vector2i(3, 0),
	"Player Start": Vector2i(4, 0),
	"Target": Vector2i(5, 0),
	"Button": Vector2i(6, 0)
}

func load_level_from_json_file(file_path: String) -> void:
	var file = FileAccess.open(file_path, FileAccess.READ)
	if not file:
		print("Failed to open file: ", file_path)
		return

	var json_text = file.get_as_text()
	var result = JSON.parse_string(json_text)

	if typeof(result) != TYPE_ARRAY:
		print("Invalid JSON format")
		return

	load_level_from_json(result)

func load_level_from_json(tile_data: Array) -> void:
	tile_map.clear() # Clear existing tiles

	for entry in tile_data:
		if not (entry.has("x") and entry.has("y") and entry.has("tile")):
			continue

		var x = int(entry["x"])
		var y = int(entry["y"])
		var tile_name = str(entry["tile"])

		if not tile_name_to_atlas_coords.has(tile_name):
			print("Unknown tile type: ", tile_name)
			continue

		var atlas_coords = tile_name_to_atlas_coords[tile_name]
		print("Placing tile:", tile_name, "at", x, y, "with atlas coords", atlas_coords)
		tile_map.set_cell(0, Vector2i(x, y), 0, atlas_coords)

	print("Level loaded successfully.")
	
func _ready():
	print(tile_map.tile_set.get_source_count())
	print(tile_map.tile_set.get_source_id(0))
	load_level_from_json_file("res://levels/sample_level.json")
