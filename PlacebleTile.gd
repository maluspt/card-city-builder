extends Node2D

@export var tile_id: int = 0
var tilemap: TileMap
var following_mouse: bool = true

func _process(delta):
	if following_mouse:
		position = get_global_mouse_position()

func _input(event):
	if following_mouse and event is InputEventMouseButton and event.pressed:
		var local_pos = tilemap.to_local(event.position)
		var cell_coords = tilemap.local_to_map(local_pos)
		replace_tile(cell_coords)
		queue_free()

func replace_tile(cell: Vector2i):
	if tilemap == null:
		return
	var tile_data = tilemap.get_cell_tile_data(0, cell)
	if tile_data and tile_data.get_custom_data("type") == "housing":
		print("Este tile é do tipo 'housing'.")
	else:
		var tile_source = tilemap.get_cell_source_id(0, cell)
		tilemap.set_cell(0, cell, tile_source, Vector2i(4, 2))
