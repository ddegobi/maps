@icon("res://interface/icon/draw_handler.png")
class_name ProxDrawHandler extends DrawHandler

const MAX_DISTANCE : int = 3

# if im making a loaded_chunks we need a way to periodically pop from stack
var loaded_chunks
# Priority queue with priority being the proximity index
var chunk_queue = []
var player : CharacterBody2D
# idk i put these here because they are constantly used by the functions, it 
# wouldn't make sense for it to be allocated and freed up hundreds of times, at
# least i think?
var pos : Vector2
var pos_in_chunk_layer : Vector2i
var idx_cq : int

func _init(d_layer : MapDrawer, c_layer : TileMapLayer, curr_player : CharacterBody2D) -> void:
	super(d_layer, c_layer)
	player = curr_player
	init_chunk_queue()

func find_positions() -> void:
	pos = player.global_position
	pos_in_chunk_layer = chunk_layer.local_to_map(pos)


func init_chunk_queue() -> void:
	find_positions()
	chunk_queue.append(ChunkPos.new(Vector2i(0,0), 0))
	chunk_queue.append(ChunkPos.new(Vector2i(1,0), 0))
	pass
	
func look_for_chunks() -> void:
	find_positions()
	print_rich("[color=FOREST_GREEN]############################################################# ", pos_in_chunk_layer)
	for i in range(pos_in_chunk_layer.x - MAX_DISTANCE/2, pos_in_chunk_layer.x + MAX_DISTANCE/2):
		for j in range(pos_in_chunk_layer.y - MAX_DISTANCE/2, pos_in_chunk_layer.y + MAX_DISTANCE/2):
			# TODO
			if true:
				var curr_chunk = Vector2i(i,j)
				add_to_chunk_queue(ChunkPos.new(curr_chunk, curr_chunk.distance_to(pos)))

func sort_by_distance(a : ChunkPos, b : ChunkPos):
	return a.dist < b.dist

func add_to_chunk_queue(chunk : ChunkPos) -> void:
	print_rich("[color=RED]count is ",chunk_queue.size())
	idx_cq = chunk_queue.bsearch_custom(chunk, sort_by_distance, false)
	print(chunk, " == ", chunk_queue[idx_cq-1])
	if true:
		chunk_queue.insert(idx_cq, chunk)
		print("inserted chunk: %s" % [chunk])

func add_to_loaded_chunks() -> void:
	pass
