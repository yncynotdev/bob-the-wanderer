class_name Orbs
extends PickUp

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		Score.score += 1
		self.queue_free()
