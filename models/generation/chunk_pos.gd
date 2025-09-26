class_name ChunkPos

var pos : Vector2i
var dist : float 

## objects used by [ProxDrawHandler] to index the chunks.

func _init(position, distance) -> void:
	pos = position
	dist = distance

func _to_string() -> String:
	return "ChunkPos{pos: %s, dist: %s}" % [pos, dist]

func equals( chunk : ChunkPos ) -> bool:
	return pos.x == chunk.pos.x and pos.y == chunk.pos.y 
