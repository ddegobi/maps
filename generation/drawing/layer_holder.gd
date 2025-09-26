class_name LayerHolder extends Node2D

@export var generator : Generator
@export var terrain_layer : TerrainLayer
@export var object_layer : TileMapLayer
@export var chunk_layer : TileMapLayer

const dsm_scene: PackedScene = preload("res://generation/drawing/drawer_state_machine.tscn")

func draw_chunk(chunk_coord : Vector2i):
	var dsm = instantiate_dsm(chunk_coord)
	add_child(dsm)
	
	

static func instantiate_dsm(chunk_coord) -> DrawerStateMachine:
	var dsm: DrawerStateMachine = dsm_scene.instantiate()
	dsm.chunk_coord = chunk_coord
	return dsm
