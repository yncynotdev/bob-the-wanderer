class_name Zones
extends AreaDetectables

@export var next_level: PackedScene

@onready var sprite: Sprite2D = $Sprite2D
@onready var collision: CollisionShape2D = $CollisionShape2D


func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		if body.key >= 1:
			body.key -= 1
			get_tree().change_scene_to_packed(next_level)
