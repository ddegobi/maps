class_name DrawerStateMachine extends Node

var initial_state: DrawerState = null
@onready var state: DrawerState = (func get_initial_state() -> DrawerState:
	return initial_state if initial_state != null else get_child(0)
).call()

var layer_holder : LayerHolder = null
var generator : Generator = null
var terrain_layer : TerrainLayer = null

var chunk_coord: Vector2i:
	set(coordinates):
		chunk_coord = coordinates

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	for state_node: DrawerState in find_children("*", "DrawerState"):
		state_node.finished.connect(_transition_to_next_state)
	
	layer_holder = get_parent() as LayerHolder
	assert( layer_holder != null, "Parent class must be or inherit [LayerHolder] class" )
	generator = layer_holder.generator
	assert( generator != null, "[LayerHolder] parent instance does not have a defined generator. 
			Try and assign a [Generator] Node in LayerHolder" )
	terrain_layer = layer_holder.terrain_layer
	assert( terrain_layer != null, "[LayerHolder] parent instance does not have a defined 
			TerrainLayer. Try and assign a [TileMapLayer] Node in LayerHolder" )
	state.enter("")

func _transition_to_next_state(target_state_path: String, data: Dictionary) -> void:
	if not has_node(target_state_path):
		print(owner.name,": Trying to transition to state ", target_state_path, " but it does not
				 exist.")
		return
	var previous_state_path = state.name
	state.exit()
	state = get_node(target_state_path)
	state.enter(previous_state_path, data)
