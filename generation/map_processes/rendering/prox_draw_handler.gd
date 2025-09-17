@icon("res://interface/icon/draw_handler.png")
class_name ProxDrawHandler extends DrawHandler

const MAX_DISTANCE : int = 10

# if im making a loaded_chunks we need a way to periodically pop from stack
var loaded_chunks = {}
# Priority queue with priority being the proximity to the player
var chunk_queue = []
var player : CharacterBody2D
# idk i put these here because they are constantly used by the functions, it 
# wouldn't make sense for it to be allocated and freed up hundreds of times, at
# least i think?
var pos : Vector2
var pos_in_chunk_layer : Vector2i
var idx_cq : int

func find_positions() -> void:
	pos = player.global_position
	pos_in_chunk_layer = chunk_layer.local_to_map(pos)

func init_chunk_queue() -> void:
	find_positions()
	chunk_queue.append(ChunkPos.new(Vector2i(0,0), 0))

func _init(d_layer : MapDrawer, c_layer : TileMapLayer, curr_player : CharacterBody2D) -> void:
	super(d_layer, c_layer)
	player = curr_player
	init_chunk_queue()

func _process(delta: float) -> void:
	for popped_chunk in chunk_queue:
		draw_layer.draw_chunk(popped_chunk.pos)
	chunk_queue.clear

## looks for chunk that need loading near the player
func look_for_chunks() -> void:
	find_positions()
	print_rich("[color=FOREST_GREEN]############################################################# ", pos_in_chunk_layer)
	for i in range(pos_in_chunk_layer.x - MAX_DISTANCE/2, pos_in_chunk_layer.x + MAX_DISTANCE/2):
		for j in range(pos_in_chunk_layer.y - MAX_DISTANCE/2, pos_in_chunk_layer.y + MAX_DISTANCE/2):
			var curr_chunk = Vector2i(i,j)
			add_to_chunk_queue(ChunkPos.new(curr_chunk, curr_chunk.distance_to(pos)))

func sort_by_distance(a : ChunkPos, b : ChunkPos) -> bool:
	return a.dist > b.dist

# if godot had a stable sort algorithm i wouldn't have to implement this
## given the index to the first element of a sequence of chunks with the same
## distance inside chunk_queue, it returns true if the given chunk equals one of
## the elements of the subsequence.
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

func add_to_loaded_chunks() -> void:
	pass

func is_chunk_not_generated(chunk : ChunkPos) -> bool:
	return not draw_layer.is_chunk_gen(chunk.pos)

## adds the [ChunkPos] object to chunk_queue if the element is not already present in it
func add_to_chunk_queue(chunk : ChunkPos) -> void:
	#print_rich("[color=RED]count is ",chunk_queue.size())
	idx_cq = chunk_queue.bsearch_custom(chunk, sort_by_distance, true)
	#print_rich("[color=YELLOW]index is ", idx_cq)
	#print(chunk_queue)
	#print(chunk, " == ", chunk_queue[idx_cq-1])
	if is_chunk_not_generated(chunk) and is_forward_equal_recursive(idx_cq, chunk) :
		chunk_queue.insert(idx_cq, chunk)
		#print("inserted chunk: %s" % [chunk])
