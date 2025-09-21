class_name LayerHolder extends Node2D
@onready var main_camera: Camera2D = $"../dummy_character/camera"

const MAIN_SOURCE_ID = 0
const PURPLE_TILE_ID = Vector2i(0,0)
const BASIC_TILESET = preload("res://basic_tileset.png")

## current character being played
var curr_character : CharacterBody2D
@export var default_layer : Drawer
@export var object_layer : Drawer
@export var generator : Generator
var default_chunk_layer : TileMapLayer
var draw_handler : DrawHandler

## If signal is emmitted, parent node will give layer_holder the character's node the player is
## currently using. [br]
signal get_curr_character

func _ready() -> void:
	default_layer.map_generator = generator
	default_chunk_layer = TileMapLayer.new()
	
	var ts : TileSet = TileSet.new()
	ts.tile_size = Vector2i( default_layer.tile_set.tile_size.x * HeightChunk.CHUNK_SIZE.x,
							 default_layer.tile_set.tile_size.y * HeightChunk.CHUNK_SIZE.y)
	default_chunk_layer.set_tile_set(ts)
	default_chunk_layer.name = StringName("chunk_layer")
	default_layer.name = StringName("base_layer")

func create_draw_handler() -> void:
	#print("create_draw_handler() called: ")
	get_curr_character.emit()
	draw_handler = ProxDrawHandler.new(default_layer, default_chunk_layer, curr_character)
	draw_handler.name = StringName("draw_handler")
	add_child(draw_handler)
