class_name PickUp
extends AreaDetectables

@onready var sprite: Sprite2D = $Sprite2D
@onready var animated_sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D


# TODO: Do not do this, only professionals can do this
func _ready() -> void:
	if !sprite:
		sprite.queue_free()
	if !animated_sprite:
		animated_sprite.queue_free()
