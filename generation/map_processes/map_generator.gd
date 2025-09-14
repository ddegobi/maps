@icon("res://interface/icon/map_generator_tileset_icon.png")
class_name MapGenerator extends Node

## Abstract Class used to Describe a generic map generator. 
## Heights ...
## are calculated here, the data is then used by [MapDrawer] to draw the actual
## tiles onto the tilemap. 

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## Must implement in subclass[br]
## Generates a [HeightChunk] object, used to determinate the height on a certain
## chunk.
func generate_chunk_at_coord(chunk_coord: Vector2i) -> HeightChunk:
	return null
