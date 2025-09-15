@icon("res://interface/icon/draw_handler.png")
class_name DemoDrawHandler extends DrawHandler

## Class handles what chunks are drawn given a [Camera2D] object
## iteration 1.0 idk

var camera : Camera2D

var pos # current position of camera
var old_pos # old position of camera
var mov # movement vector

var viewport_rect : Rect2
var visible_top_left
var visible_bottom_right
var visible_top_right
var visible_bottom_left

func _init(d_layer : MapDrawer, c_layer : TileMapLayer, cam : Camera2D) -> void:
	super(d_layer, c_layer)
	camera = cam

func _ready() -> void:
	old_pos = camera.position
	pass

func _process(delta: float) -> void:
	viewport_rect = chunk_layer.get_viewport_rect()
	# instead basing the positions on the camera we could base it on the viewport rectangle?
	pos = camera.global_position
	
	mov = pos - old_pos
	visible_top_left = chunk_layer.local_to_map(chunk_layer.to_local(camera.get_screen_center_position() - camera.get_viewport_rect().size / 2))
	visible_bottom_right = chunk_layer.local_to_map(chunk_layer.to_local(camera.get_screen_center_position() + camera.get_viewport_rect().size / 2))
	visible_top_right = Vector2i(visible_bottom_right.x, visible_top_left.y)
	visible_bottom_left = Vector2i(visible_top_left.x, visible_bottom_right.y)
	#print(visible_top_left)
	var chunks
	#print("printing mov: ", mov)
	# checks if there is movement
	if mov:
		var angle = mov.angle()
		# player is moving top
		if angle < 0:
			chunks = list_of_vectors2i(visible_top_left, visible_top_right)
			# player is moving top right
			if angle > -PI/2:
				chunks.append_array(list_of_vectors2i(visible_top_right, visible_bottom_right))
			# player is moving top left
			else:
				chunks.append_array(list_of_vectors2i(visible_top_left, visible_bottom_left))
		# player is moving bottom
		else:
			chunks = list_of_vectors2i(visible_bottom_left, visible_bottom_right)
			# player is moving bottom right
			if angle < PI/2:
				chunks.append_array(list_of_vectors2i(visible_top_right, visible_bottom_right))
			# player is moving bottom left
			else:
				chunks.append_array(list_of_vectors2i(visible_top_left, visible_bottom_left))
		call_for_draw(chunks)
		#print(chunks)
	old_pos = pos

## returns a list of all the possible vector inbetween min and max
func list_of_vectors2i(min : Vector2i, max : Vector2i):
	var list = []
	for i in range(min.x, max.x+1):
		for j in range(min.y, min.y+1):
			list.append(Vector2i(i,j))
	return list

## given a list of chunks ([Vector2i]) calls for them to be drawn
