extends DrawerState

var tl : TerrainLayer

func enter(previous_state_path: String, data := {}) -> void:
	tl = dsm.terrain_layer
	tl.add_child(data[CHUNK])
	dsm.queue_free()
