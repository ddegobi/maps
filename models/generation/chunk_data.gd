class_name ChunkData extends TileMapLayer

enum TileType{
	WATER,
	GRASS,
}

func _init(init_tileset : TileSet) -> void:
	tile_set = init_tileset

## matrix containing height for every element in chunk
var height_chunk: HeightChunk = null
## matrix containing tile type for every element in chunk
var type_chunk = []
