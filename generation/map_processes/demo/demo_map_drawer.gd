@icon("res://interface/icon/map_drawer_icon.png")
class_name DemoMapDrawer extends MapDrawer

## Draws the basic map [br]
## The class is the grandchild of [TileMapLayer] and it renders the tiles using
## the prebuilt structures. There is a custom data layer added which is the
## height data associated which is given cell.
## 
## SingleThreadImplementation

#grass_tileset
const GRASS_TILESET = preload("res://textures/tilesets/grass_tileset.png")
# tileset size
const TILESET_SIZE : Vector2i = Vector2i(8,8)
# position of defualt tiles
const DEFAULT_TILE : Vector2i = Vector2i(0,0)
const SECOND_TILE : Vector2i = Vector2i(0,1)
# positions of tiles in atlas
const OUTER_TOP_RIGHT = Vector2i(2, 0)
const OUTER_TOP_LEFT = Vector2i(0, 0)
const OUTER_BOTTOM_RIGHT = Vector2i(2, 2)
const OUTER_BOTTOM_LEFT = Vector2i(0, 2)
const OUTER_BOTTOM = Vector2i(1, 2)
const OUTER_TOP = Vector2i(1, 0)
const OUTER_LEFT = Vector2i(0, 1)
const OUTER_RIGHT = Vector2i(2, 1)
const FULL = Vector2i(1,1)
const FULL_ALT = Vector2i(5,0)
# alternative tiles ids
enum alt_tiles {
	NORMAL = 1,
	FLIP_H = 2,
	FLIP_V = 3,
	FLIP_HV = 4,
}
enum cell_types {
	GRASS,
	WATER,
}
var atlas_coord_map = {
	"0000" : FULL,
	"0001" : OUTER_BOTTOM,
	"0010" : OUTER_RIGHT,
	"0011" : OUTER_BOTTOM_RIGHT,
	"0100" : OUTER_LEFT,
	"0101" : OUTER_BOTTOM_LEFT,
	"0110" : FULL_ALT, # TODO MAPPING!
	"0111" : FULL_ALT, # TODO MAPPING!
	"1000" : OUTER_TOP,
	"1001" : FULL_ALT, # TODO MAPPING!
	"1010" : OUTER_TOP_RIGHT,
	"1011" : FULL_ALT, # TODO MAPPING!
	"1100" : OUTER_TOP_LEFT,
	"1101" : FULL_ALT, # TODO MAPPING!
	"1110" : FULL_ALT, # TODO MAPPING!
	"1111" : FULL_ALT,
}

# ids of different atlases atlas ###############################################
var default_source_id : int
var grass_to_water_id : int
## [MapGenerator] object that is going to be utilized by drawer
var map_generator : MapGenerator


# Constructor
func _init(default_tileset_texture : Texture2D, generator : MapGenerator) -> void:
	var ts : TileSet = TileSet.new()
	
	map_generator = generator
	ts.tile_size = TILESET_SIZE
	
	# basic_tileset.png ADDED
	default_source_id = ts.add_source(create_atlas(default_tileset_texture))
	print(default_source_id)
	# grass_tileset.png ADDED
	grass_to_water_id = ts.add_source(create_atlas(GRASS_TILESET))
	print(grass_to_water_id)
	
	set_tile_set(ts)

func _init_atlas_coord_map() -> void:
	
	pass

func create_atlas(texture) -> TileSetAtlasSource:
	var ts_source : TileSetAtlasSource = TileSetAtlasSource.new()
	ts_source.texture = texture
	ts_source.texture_region_size = TILESET_SIZE
	create_tiles(ts_source)
	
	return ts_source
	

## simple function that automatically create the tiles in the atlas
func create_tiles(atlas : TileSetAtlasSource) -> void:
	var atlas_size = atlas.get_atlas_grid_size()
	# defining tiles
	for i in range(atlas_size.x):
		for j in range(atlas_size.y):
			atlas.create_tile(Vector2i(i,j))
			
	# creating alt tiles in tile set
	# creating normal tile alt
	atlas.create_alternative_tile(FULL, alt_tiles.NORMAL)
	# creating horizontal flip
	atlas.create_alternative_tile(FULL, alt_tiles.FLIP_H)
	atlas.get_tile_data(FULL, alt_tiles.FLIP_H).flip_h = true
	#creating vertical flip
	atlas.create_alternative_tile(FULL, alt_tiles.FLIP_V)
	atlas.get_tile_data(FULL, alt_tiles.FLIP_H).flip_v = true
	# creating both vertical and horizontal flip
	atlas.create_alternative_tile(FULL, alt_tiles.FLIP_HV)
	atlas.get_tile_data(FULL, alt_tiles.FLIP_HV).flip_v = true
	atlas.get_tile_data(FULL, alt_tiles.FLIP_HV).flip_h = true



func get_coords_from_chunk(chunk_coord : Vector2i,
			chunk_size : Vector2i, 
			pos_x : int, 
			pos_y : int) -> Vector2i:
	return Vector2i((chunk_coord.x*chunk_size.x)+pos_x, (chunk_coord.y*chunk_size.y)+pos_y)

func is_chunk_gen(chunk_coord : Vector2i) -> bool:
	return get_node_or_null("%s_%s" % [str(chunk_coord.x), str(chunk_coord.y)]) != null
	

func _create_chunk_tilemap(chunk_coord) -> TileMapLayer:
	var chunk = ChunkDrawer.new(chunk_coord)
	chunk.name = "%s_%s" % [str(chunk_coord.x), str(chunk_coord.y)]
	chunk.set_tile_set(tile_set)
	return chunk

func _paint_chunk(chunk : ChunkDrawer) -> void:
	var height_chunk = map_generator.generate_chunk_at_coord(chunk.chunk_coord)
	var type_chunk = []
	var tile_data : TileData
	
	for i in HeightChunk.CHUNK_SIZE.x + 2:
		type_chunk.append([])
		for j in HeightChunk.CHUNK_SIZE.y + 2:
			var height_data = height_chunk.grid[i][j]
			if height_data < 0:
				type_chunk[i].append(cell_types.WATER)
			else:
				type_chunk[i].append(cell_types.GRASS)
	
	for i in range(1, HeightChunk.CHUNK_SIZE.x+1):
		for j in range(1, HeightChunk.CHUNK_SIZE.y+1):
			var coord = get_coords_from_chunk(chunk.chunk_coord,HeightChunk.CHUNK_SIZE,i,j)
			#var height_data = height_chunk.grid[i][j]
			if type_chunk[i][j] == cell_types.WATER:
				chunk.set_cell(coord, grass_to_water_id, FULL_ALT)
			else:
				var mini_matrix = type_chunk.slice(i-1, i+2)
				for row in range(3):
					mini_matrix[row] = mini_matrix[row].slice(j-1, j+2)
				var atlas_coords = _determine_atlas_coord(cell_types.GRASS, cell_types.WATER, mini_matrix)
				var alt_tile = randi() % alt_tiles.size()
				if atlas_coords == FULL:
					chunk.set_cell(coord, grass_to_water_id, atlas_coords, alt_tile)
				else:
					chunk.set_cell(coord, grass_to_water_id, atlas_coords)
					

func _determine_atlas_coord(type, alt_type, mini_matrix) -> Vector2i:
	var str : String
	var m = []
	for i in mini_matrix.size():
		m.append([])
		for j in mini_matrix.size():
			if mini_matrix[i][j] == type:
				m[i].append(0)
			else:
				m[i].append(1)
	str = str(m[1][0],m[0][1],m[2][1],m[1][2])
	return atlas_coord_map[str]
	
## Draws the passed chunk onto the tilemap
func draw_chunk(chunk_coord : Vector2i) -> void:
	if( not is_chunk_gen(chunk_coord) ):
		var thread = Thread.new()
		thread.start(_bg_chunk_load.bind(chunk_coord, thread))
	
func _bg_chunk_load(chunk_coord : Vector2i, thread : Thread):
	var chunk = _create_chunk_tilemap(chunk_coord)
	_paint_chunk(chunk)
	call_deferred("_bg_chunk_load_done", thread)
	return chunk

func _bg_chunk_load_done(thread : Thread) -> void:
	var chunk = thread.wait_to_finish()
	add_child(chunk)
