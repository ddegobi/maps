@icon("res://interface/icon/map_drawer_icon.png")
class_name MapDrawer extends TileMapLayer

func draw_chunk(_chunk_coord : Vector2i) -> void:
	pass

func is_chunk_gen(_chunk_coord : Vector2i) -> bool:
	return false
