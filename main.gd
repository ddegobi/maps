extends Node2D

var curr_character : CharacterBody2D
var layer_holder_node : LayerHolder

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_character = get_node("dummy_character")
	layer_holder_node = get_node("layer_holder")
	layer_holder_node.get_curr_character.connect(give_character_to_layer_holder)
	layer_holder_node.create_draw_handler()
	print(layer_holder_node.curr_character)


func give_character_to_layer_holder() -> void:
	layer_holder_node.curr_character = curr_character
