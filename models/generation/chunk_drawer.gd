class_name ChunkDrawer extends TileMapLayer

var chunk_coord : Vector2i

func _init(arg_chunk_coord : Vector2i) -> void:
	self.chunk_coord = arg_chunk_coord
