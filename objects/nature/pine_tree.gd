extends AnimatableBody2D

@export var speed_variance : float = 5
#IDS OF CHILDREN
enum ids{
	ANIMATED_SPRITE,
	COLLISION_POLIGON,
}
var speed : float

# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	var anim_speed = randf()/speed_variance + 1-(1/speed_variance*2)
	var start_frame = str(randi() % 5)
	var anim_sprite : AnimatedSprite2D =  get_child(ids.ANIMATED_SPRITE)
	anim_sprite.play(&"", anim_speed)
