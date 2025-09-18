@icon("res://interface/icon/map_generator_tileset_icon.png")
class_name MapGenerator extends Node

## Abstract Class used to Describe a generic map generator. 
## Heights ...
## are calculated here, the data is then used by [MapDrawer] to draw the actual
## tiles onto the tilemap. 

func generate_chunk_at_coord(_chunk_coord: Vector2i) -> HeightChunk:
	return null

func generate_height_tile_at_coord(_tile_coord: Vector2i) -> int:
	return 0
