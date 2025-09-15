@icon("res://interface/icon/map_drawer_icon.png")
class_name DemoMapDrawer extends MapDrawer

## Draws the basic map [br]
## The class is the grandchild of [TileMapLayer] and it renders the tiles using
## the prebuilt structures. There is a custom data layer added which is the
## height data associated which is given cell.
## 
## SingleThreadImplementation


const DEFAULT_TILE : Vector2i = Vector2i(0,0)
const SECOND_TILE : Vector2i = Vector2i(0,1)
const HEIGHT_MAP_LAYER = "height_map_layer"

## id of first atlas added
var main_source_id = null
## [MapGenerator] object that is going to be utilized by drawer
var map_generator : MapGenerator
var height_data = 0

# Constructor
func _init(tileset_texture : Texture2D, generator : MapGenerator) -> void:
	var ts : TileSet = TileSet.new()
	var ts_source : TileSetAtlasSource = TileSetAtlasSource.new()
	
	map_generator = generator
	ts.tile_size = Vector2i(8,8)
	ts_source.texture = tileset_texture
	ts_source.texture_region_size = Vector2i(8,8)
	create_tiles(ts_source)
	main_source_id = ts.add_source(ts_source)
	ts.add_custom_data_layer()
	# CUSTOM LAYER "height_map_layer"
	var height_map_layer_id = ts.get_custom_data_layers_count()-1
	ts.set_custom_data_layer_name(height_map_layer_id, HEIGHT_MAP_LAYER)
	ts.set_custom_data_layer_type(height_map_layer_id, TYPE_INT)

	set_tile_set(ts)

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	# test
	for i in range(10):
		for j in range(10):
			draw_chunk(Vector2i(i,j))
			# print("is chunk generated? ", is_chunk_gen(Vector2i(i,j)))
	# print("is chunk generated? ", is_chunk_gen(Vector2i(-1,-1)))

## simple function that automatically create the tiles in the atlas
func create_tiles(atlas : TileSetAtlasSource) -> void:
	var atlas_size = atlas.get_atlas_grid_size()
	for i in range(atlas_size.x):
		for j in range(atlas_size.y):
			atlas.create_tile(Vector2i(i,j))

func get_coords_from_chunk(chunk_coord : Vector2i,
			chunk_size : Vector2i, 
			pos_x : int, 
			pos_y : int) -> Vector2i:
	return Vector2i((chunk_coord.x*chunk_size.x)+pos_x, (chunk_coord.y*chunk_size.y)+pos_y)

func is_chunk_gen(chunk_coord) -> bool:
	return get_cell_tile_data( get_coords_from_chunk(chunk_coord,HeightChunk.CHUNK_SIZE,0,0)) != null

## Draws the passed chunk onto the tilemap
func draw_chunk(chunk_coord : Vector2i) -> void:
	var verbose = false
	# get_coords_from_chunk(chunk_coord,HeightChunk.CHUNK_SIZE,0,0)
	# is_chunk_gen(chunk_coord)
	if( !is_chunk_gen(chunk_coord) ):
		if verbose:
			print("Generating chunk: ", chunk_coord.x,", " ,chunk_coord.y)
		var height_chunk = map_generator.generate_chunk_at_coord(chunk_coord)
		var tile_data : TileData
		for i in HeightChunk.CHUNK_SIZE.x:
			for j in HeightChunk.CHUNK_SIZE.y:
				height_data = height_chunk.grid[i][j]
				if height_data < 0:
					set_cell(get_coords_from_chunk(chunk_coord,HeightChunk.CHUNK_SIZE,i,j),
							 main_source_id,
							 DEFAULT_TILE)
				else:
					set_cell(get_coords_from_chunk(chunk_coord,HeightChunk.CHUNK_SIZE,i,j),
							 main_source_id,
							 SECOND_TILE)
							
				tile_data = get_cell_tile_data(Vector2i((chunk_coord.x*HeightChunk.CHUNK_SIZE.x)+i,
														(chunk_coord.y*HeightChunk.CHUNK_SIZE.y)+j))
				tile_data.set_custom_data(HEIGHT_MAP_LAYER, height_data)
