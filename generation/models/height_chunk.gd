class_name HeightChunk

static var CHUNK_SIZE : Vector2i = Vector2i(16,16)
static var BIT_32_RANGE : int = 4294967296

var grid = []

func _init() -> void:
	for i in CHUNK_SIZE.x:
		grid.append(PackedInt32Array())
		for j in CHUNK_SIZE.y:
			grid[i].append(0)
