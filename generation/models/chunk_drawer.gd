class_name ChunkDrawer extends TileMapLayer

var chunk_coord : Vector2i

func _init(chunk_coord : Vector2i) -> void:
	self.chunk_coord = chunk_coord
