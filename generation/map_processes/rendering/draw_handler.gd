@icon("res://interface/icon/draw_handler.png")
class_name DrawHandler extends Node

var draw_layer : MapDrawer
var chunk_layer : TileMapLayer

func _init(d_layer : MapDrawer, c_layer : TileMapLayer) -> void:
	draw_layer = d_layer
	chunk_layer = c_layer

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func call_for_draw(chunks) -> void:
	for chunk_pos in chunks:
		draw_layer.draw_chunk(chunk_pos)
