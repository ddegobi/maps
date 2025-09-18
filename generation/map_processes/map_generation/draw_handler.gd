@icon("res://interface/icon/draw_handler.png")
class_name DrawHandler extends Node

@export_range(0, 1, 0.05, "suffix:s", "or_greater")
var chunk_check_delay : float = 0.1
var chunk_check_timer = Timer.new()
var draw_layer : MapDrawer
var chunk_layer : TileMapLayer

func _init(d_layer : MapDrawer, c_layer : TileMapLayer) -> void:
	draw_layer = d_layer
	chunk_layer = c_layer
	
func _ready() -> void:
	_init_timer()
	start_chunk_gen()
	
func start_chunk_gen() -> void:
	chunk_check_timer.start()
	
func _init_timer() -> void:
	add_child(chunk_check_timer)
	chunk_check_timer.wait_time = chunk_check_delay
	chunk_check_timer.one_shot = false
	chunk_check_timer.connect("timeout", look_for_chunks)

func look_for_chunks() -> void:
	pass

func call_for_draw(chunks) -> void:
	for chunk_pos in chunks:
		draw_layer.draw_chunk(chunk_pos)
