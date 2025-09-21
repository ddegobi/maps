@icon("res://interface/icon/placeable_tree.png")
class_name PlaceableTree extends PlaceableObject
## A tree object that can be placed on the object layer, all trees have an
## animation related to the wind strength

@export_subgroup("Sprite Animations")
## Sprite that will be used to apply the wind animation effect on
@export var animated_sprite : AnimatedSprite2D
## the range of values 
@export_range(0, 0.9, 0.05) var speed_variance : float = 0.3
@export_range(0, 0.2, 0.005) var skewness : float = 0.015
@export_range(0.2, 5, 0.2) var swing_time : float = 1.5
@export_range(0, 1, 0.1) var wait_time : float = 0.1
var speed : float
var tween

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	if Engine.is_editor_hint():
		pass
	var anim_speed = randf()*speed_variance + 1-(speed_variance/2)
	var start_frame = randi() % 5
	animated_sprite.speed_scale = anim_speed
	animated_sprite.frame = start_frame
	# maybe creating a tween for each and every tree is not sensible but one 
	# must persevere
	tween = create_tween().set_loops()
	tween.tween_property(animated_sprite, "skew", -skewness, swing_time )
	tween.tween_interval(wait_time)
	tween.tween_property(animated_sprite, "skew", skewness, swing_time )
	#tween.tween_property(animated_sprite, "skew", skewness, 2 )
