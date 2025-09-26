extends Node2D

enum States {ROAMING, BUILDING}

var state : States = States.ROAMING 

var curr_character : CharacterBody2D
@onready var draw_handler_node : ProximityDrawHandler = get_node("DrawingBoard/ProximityDrawHandler")

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	curr_character = get_node("dummy_character")
	draw_handler_node.get_curr_character.connect(give_character_to)
	print(draw_handler_node.player)
	
	var button = Button.new()
	button.text = "switch states"
	button.pressed.connect(_button_pressed)
	add_child(button)

func _button_pressed():
	if state == States.ROAMING:
		state = States.BUILDING
	elif state == States.BUILDING:
		state = States.ROAMING

func give_character_to() -> void:
	draw_handler_node.player = curr_character
