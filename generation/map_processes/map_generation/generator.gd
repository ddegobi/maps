@icon("res://interface/icon/map_generator_tileset_icon.png")
class_name Generator extends Node

# TODO
@export var temp_seed = 7

var noise = FastNoiseLite.new()
var base = HeightChunk.new()

func _init() -> void:
	noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
	noise.seed = temp_seed
	noise.fractal_octaves = 4
	noise.frequency = 1.0 / 20.0
	
	for i in HeightChunk.CHUNK_SIZE.x:
		for j in HeightChunk.CHUNK_SIZE.y:
			base.grid[i][j] = 0

## generates a heightmap using the simplex algorithm. it returns a [HeightChunk]
## object containing the heights.
func generate_chunk_at_coord(chunk_coord: Vector2i) -> HeightChunk:
	var height_chunk = HeightChunk.new()
	for i in height_chunk.CHUNK_SIZE.x + 2:
		for j in height_chunk.CHUNK_SIZE.y + 2:
			height_chunk.grid[i][j] = int( noise.get_noise_2d(chunk_coord.x + (1/float(HeightChunk.CHUNK_SIZE.x ))*i-1, chunk_coord.y + (1/float(HeightChunk.CHUNK_SIZE.y))*j-1) * height_chunk.BIT_32_RANGE - (height_chunk.BIT_32_RANGE/2) )
	return height_chunk
