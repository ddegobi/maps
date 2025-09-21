@icon("res://interface/icon/drawer.png")
class_name Drawer extends TileMapLayer

# abstract
func draw_chunk(_chunk_coord : Vector2i) -> void:
	pass

# abstract
func is_chunk_gen(_chunk_coord : Vector2i) -> bool:
	return false

# abstract
func delete_chunk(_chunk_coord : Vector2i) -> void:
	pass
