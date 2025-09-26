@icon("res://interface/icon/draw_handler.png")
class_name ProximityDrawHandler extends Node

signal get_curr_character

@export_range(0, 1, 0.05, "suffix:s", "or_greater")
var chunk_check_delay : float = 0.1
var chunk_check_timer = Timer.new()
var layer_holder : LayerHolder = null
var chunk_layer : TileMapLayer = null

## Class handles what chunks are to be drawn and which chunks are to be wiped.
## In particular, ProxDrawHandler makes this choice based on the position of the
## player on the [TileMapLayer] tilemap.

const MAX_DISTANCE : int = 12
const NUMBER_OF_CHUNKS_DRAWN : int = 3

# if im making a loaded_chunks we need a way to periodically pop from stack
var loaded_chunks = {}
# Priority queue with priority being the proximity to the player when the chunk
# was called to be drawn
var chunk_queue = []
var player : CharacterBody2D

# idk i put these here because they are constantly used by the functions, it 
# wouldn't make sense for it to be allocated and freed up hundreds of times, at
# least i think? maybe premature optimization
var pos : Vector2
var pos_in_chunk_layer : Vector2i
var idx_cq : int

## checks for position of player in the world and which chunk it's in
func find_positions() -> void:
	pos = player.global_position
	pos_in_chunk_layer = chunk_layer.local_to_map(pos)

func init_chunk_queue() -> void:
	chunk_queue.append(ChunkPos.new(Vector2i(0,0), 0))

func _init() -> void:
	init_chunk_queue()
	
func _process(_delta: float) -> void:
	var chunk_q_size = chunk_queue.size()
	if chunk_q_size > NUMBER_OF_CHUNKS_DRAWN:
		for popped_chunk in chunk_queue.slice(-NUMBER_OF_CHUNKS_DRAWN,-1):
			layer_holder.draw_chunk(popped_chunk.pos)
			loaded_chunks[popped_chunk.pos] = popped_chunk
		chunk_queue.resize(chunk_queue.size()-NUMBER_OF_CHUNKS_DRAWN)
	elif chunk_q_size > 0:
		for popped_chunk in chunk_queue:
			layer_holder.draw_chunk(popped_chunk.pos)
			loaded_chunks[popped_chunk.pos] = popped_chunk
		chunk_queue.clear()

## Function looks for chunks to be added to chunk_queue, gets periodically 
## called by timer.
func look_for_chunks() -> void:
	find_positions()
	print_rich("[color=FOREST_GREEN]##########################", pos_in_chunk_layer)
	for i in range(pos_in_chunk_layer.x - int(float(MAX_DISTANCE)/2),
				   pos_in_chunk_layer.x + int(float(MAX_DISTANCE)/2) ):
		for j in range(pos_in_chunk_layer.y - int(float(MAX_DISTANCE)/2),
					   pos_in_chunk_layer.y + int(float(MAX_DISTANCE)/2) ):
			var curr_chunk = Vector2i(i,j)
			add_to_chunk_queue(ChunkPos.new(curr_chunk, curr_chunk.distance_to(pos)))

func sort_by_distance(a : ChunkPos, b : ChunkPos) -> bool:
	return a.dist < b.dist

# if godot had a stable sort algorithm i wouldn't have to implement this........
## Given the index to the first element of a sequence of chunks with the same
## distance inside chunk_queue, it returns true if the given chunk equals one of
## the subsequent chunks.
func is_forward_equal_recursive(index : int, chunk : ChunkPos) -> bool:
	if index < chunk_queue.size():
		if chunk_queue[index].dist == chunk.dist:
			if chunk_queue[index].equals(chunk):
				return false
			else:
				return is_forward_equal_recursive(index+1, chunk)
		else:
			return true
	else:
		return true

func is_chunk_not_generated(chunk : ChunkPos) -> bool:
	return not loaded_chunks.has(chunk.pos)

## adds the [ChunkPos] object to chunk_queue if the element is not already
## present in it
func add_to_chunk_queue(chunk : ChunkPos) -> void:
	idx_cq = chunk_queue.bsearch_custom(chunk, sort_by_distance, true)
	if is_chunk_not_generated(chunk) and is_forward_equal_recursive(idx_cq, chunk):
		chunk_queue.insert(idx_cq, chunk)

func _ready() -> void:
	await owner.ready
	get_curr_character.emit()
	_init_timer()
	layer_holder = get_parent().find_children("*", "LayerHolder")[0]
	chunk_layer = layer_holder.chunk_layer
	start_chunk_gen()
	
	
func start_chunk_gen() -> void:
	chunk_check_timer.start()
	
func _init_timer() -> void:
	add_child(chunk_check_timer)
	chunk_check_timer.wait_time = chunk_check_delay
	chunk_check_timer.one_shot = false
	chunk_check_timer.connect("timeout", look_for_chunks)
