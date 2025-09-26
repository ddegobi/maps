extends DrawerState 

func enter(previous_state_path: String, data := {}) -> void:
	data[CHUNK] = draw()
	finished.emit(default_next_state, data)

func draw() -> ChunkData:
	var generator = dsm.generator
	var height_chunk = generator.generate_chunk_at_coord(dsm.chunk_coord)
	var type_chunk = []
	
	var tile_types = ChunkData.TileType
	for i in HeightChunk.CHUNK_SIZE.x + 2:
		type_chunk.append([])
		for j in HeightChunk.CHUNK_SIZE.y + 2:
			var height_data = height_chunk.grid[i][j]
			if height_data < 0:
				type_chunk[i].append(tile_types.WATER)
			else:
				type_chunk[i].append(tile_types.GRASS)

	var chunk_data = ChunkData.new(dsm.terrain_layer.tileset)
	chunk_data.height_chunk = height_chunk
	chunk_data.type_chunk = type_chunk
	return chunk_data
