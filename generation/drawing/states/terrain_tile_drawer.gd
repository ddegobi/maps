extends DrawerState

var chunk : ChunkData
var tl : TerrainLayer

func enter(previous_state_path: String, data := {}) -> void:
	tl = dsm.terrain_layer
	chunk = data[CHUNK]
	data[CHUNK] = draw()
	finished.emit(default_next_state, data)
	

func draw() -> ChunkData:
	var tile_types = ChunkData.TileType
	for i in range(1, HeightChunk.CHUNK_SIZE.x+1):
		for j in range(1, HeightChunk.CHUNK_SIZE.y+1):
			var coord = get_coords_from_chunk(dsm.chunk_coord,HeightChunk.CHUNK_SIZE,i,j)
			#var height_data = height_chunk.grid[i][j]
			
			if chunk.type_chunk[i][j] == tile_types.WATER:
				chunk.set_cell(coord, tl.grass_to_water_id, tl.FULL_ALT)
			else:
				var mini_matrix = chunk.type_chunk.slice(i-1, i+2)
				for row in range(3):
					mini_matrix[row] = mini_matrix[row].slice(j-1, j+2)
				var atlas_coords = _determine_atlas_coord(tile_types.GRASS, mini_matrix)
				var alt_tile = randi() % tl.alt_tiles.size()
				if atlas_coords == tl.FULL:
					chunk.set_cell(coord, tl.grass_to_water_id, atlas_coords, alt_tile)
				else:
					chunk.set_cell(coord, tl.grass_to_water_id, atlas_coords)
	chunk.name = str( "(",dsm.chunk_coord.x,",",dsm.chunk_coord.y,")" )
	return chunk

func get_coords_from_chunk(chunk_coord : Vector2i,
			chunk_size : Vector2i, 
			pos_x : int, 
			pos_y : int) -> Vector2i:
	return Vector2i((chunk_coord.x*chunk_size.x)+pos_x, (chunk_coord.y*chunk_size.y)+pos_y)

func _determine_atlas_coord(type, mini_matrix) -> Vector2i:
	var key_str : String
	var m = []
	for i in mini_matrix.size():
		m.append([])
		for j in mini_matrix.size():
			if mini_matrix[i][j] == type:
				m[i].append(0)
			else:
				m[i].append(1)
	key_str = str(m[1][0],m[0][1],m[2][1],m[1][2])
	return tl.atlas_coord_map[key_str]
