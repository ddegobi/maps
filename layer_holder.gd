class_name LayerHolder extends Node2D
@onready var outside_layer: TileMapLayer = $outside_layer
@onready var main_camera: Camera2D = $"../dummy_character/camera"

const MAIN_SOURCE_ID = 0
const PURPLE_TILE_ID = Vector2i(0,0)
const BASIC_TILESET = preload("res://basic_tileset.png")

## current character being played
var curr_character : CharacterBody2D
var default_layer : MapDrawer
var default_chunk_layer : TileMapLayer
var draw_handler : DrawHandler
var seed_int : int

## If signal is emmitted, parent node will give layer_holder the character's node the player is
## currently using. [br]
signal get_curr_character

func _ready() -> void:
	seed_int = 7
	default_layer = DemoMapDrawer.new(BASIC_TILESET, DemoMapGenerator.new(seed_int))
	# we could try and make this a separate class to make the code cleaner (and we can do something
	# something other than the basic things too with the chunks that are relevant)
	default_chunk_layer = TileMapLayer.new()
	var ts : TileSet = TileSet.new()
	ts.tile_size = Vector2i( default_layer.tile_set.tile_size.x * HeightChunk.CHUNK_SIZE.x,
							 default_layer.tile_set.tile_size.y * HeightChunk.CHUNK_SIZE.y)
	default_chunk_layer.set_tile_set(ts)
	#var default_draw_handler = DemoDrawHandler.new(default_layer, default_chunk_layer,main_camera)
	
	default_chunk_layer.name = StringName("chunk_layer")
	default_layer.name = StringName("base_layer")
	
	add_child(default_chunk_layer)
	add_child(default_layer)
	#add_child(default_draw_handler)

# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func create_draw_handler() -> void:
	#print("create_draw_handler() called: ")
	get_curr_character.emit()
	draw_handler = ProxDrawHandler.new(default_layer, default_chunk_layer, curr_character)
	draw_handler.name = StringName("draw_handler")
	add_child(draw_handler)
