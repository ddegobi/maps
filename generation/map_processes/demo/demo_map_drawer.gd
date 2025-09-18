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
	NORMAL,
	FLIP_H,
	FLIP_V,
	FLIP_HV,
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
	var tile_data : TileData
	for i in HeightChunk.CHUNK_SIZE.x:
		for j in HeightChunk.CHUNK_SIZE.y:
			var coord = get_coords_from_chunk(chunk.chunk_coord,HeightChunk.CHUNK_SIZE,i,j)
			var height_data = height_chunk.grid[i][j]
			if height_data < 0:
				chunk.set_cell(coord, grass_to_water_id, FULL_ALT)
			else:
				var alt_tile = randi() % alt_tiles.size()
				chunk.set_cell(coord, grass_to_water_id, FULL, alt_tile)
			
## Draws the passed chunk onto the tilemap
func draw_chunk(chunk_coord : Vector2i) -> void:
	
	if( not is_chunk_gen(chunk_coord) ):
		"""
		var chunk = _create_chunk_tilemap(chunk_coord)
		_paint_chunk(chunk)
		add_child(chunk)
		"""
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
