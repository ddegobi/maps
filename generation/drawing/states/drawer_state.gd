class_name DrawerState extends Node

@export_enum(
		"HeightMapDrawer",
		"LandDrawer",
		"BiomeDrawer",
		"RiverDrawer",
		"TerrainTileDrawer",
		"AddChunkToTree",
		"EndState",
) var default_next_state: String

const HEIGHT_MAP_DRAWER = "HeightMapDrawer"
const LAND_DRAWER = "LandDrawer"
const BIOME_DRAWER =  "BiomeDrawer"
const RIVER_DRAWER = "RiverDrawer"
const TERRAIN_TILE_DRAWER = "TerrainTileDrawer"
const ADD_CHUNK_TO_TREE = "AddChunkToTree"
const END_STATE = "EndState"

# variables inside data
const CHUNK = "chunk"

signal finished(next_state_path: String, data: Dictionary)

@onready var dsm: DrawerStateMachine = owner

func _ready() -> void:
	assert(default_next_state != null, name + ": default_next_state was not set :C")

func enter(previous_state_path: String, data := {}) -> void:
	pass

func exit() -> void:
	pass

func draw() -> ChunkData:
	return
