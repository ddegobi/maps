@icon("res://interface/icon/map_generator_tileset_icon.png")
class_name DemoMapGenerator extends MapGenerator

var noise = FastNoiseLite.new()

func _init(seed_int) -> void:
	noise.noise_type = FastNoiseLite.NoiseType.TYPE_SIMPLEX_SMOOTH
	noise.seed = seed_int
	noise.fractal_octaves = 4
	noise.frequency = 1.0 / 4.0

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

## generates a heightmap using the simplex algorithm. it returns a [HeightChunk]
## object containing the heights.
func generate_chunk_at_coord(chunk_coord: Vector2i) -> HeightChunk:
	var height_chunk = HeightChunk.new()
	for i in height_chunk.CHUNK_SIZE.x:
		for j in height_chunk.CHUNK_SIZE.y:
			#print("noise at xy: ", noise.get_noise_2d(chunk_coord.x + (1/float(HeightChunk.CHUNK_SIZE.x ))*i, chunk_coord.y + (1/float(HeightChunk.CHUNK_SIZE.y))*j)  )
			#print("height at xy: ", int( noise.get_noise_2d(chunk_coord.x + (1/float(HeightChunk.CHUNK_SIZE.x ))*i, chunk_coord.y + (1/float(HeightChunk.CHUNK_SIZE.y))*j) * height_chunk.BIT_32_RANGE - (height_chunk.BIT_32_RANGE/2) ) )
			#print("x: ", float(chunk_coord.x) + (1/(i+1)), " y: ", (float(chunk_coord.y) + (1/(j+1))))
			#print(noise.get_noise_2d( (chunk_coord.x + (1/(i+1))), (chunk_coord.y + (1/(j+1)))))
			height_chunk.grid[i][j] = int( noise.get_noise_2d(chunk_coord.x + (1/float(HeightChunk.CHUNK_SIZE.x ))*i, chunk_coord.y + (1/float(HeightChunk.CHUNK_SIZE.y))*j) * height_chunk.BIT_32_RANGE - (height_chunk.BIT_32_RANGE/2) )
	# print(height_chunk.grid)
	return height_chunk
