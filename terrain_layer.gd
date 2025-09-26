@icon("res://interface/icon/map_drawer.png")
class_name TerrainLayer extends TileMapLayer

# alternative tiles IDs
enum alt_tiles {
	NORMAL = 0,
	FLIP_H = 1,
	FLIP_V = 2,
	FLIP_HV = 3,
}
enum cell_types {
	GRASS,
	WATER,
}

# grass_tileset
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

# im sorry to myself if i don't know what this means in like a year or something
## Lookup table:[br]
## key: 4 characters corrisponding to top-left-right-bottom positions around a
## cell. 
## character is 0 if the cell in that position is the main tile, 1 if not.[br]
## value: [Vector2i], rappresenting the atlas position to use.
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

var tileset : TileSet = get_tile_set()

# ids of different atlas #######################################################
var grass_to_water_id : int = 0
