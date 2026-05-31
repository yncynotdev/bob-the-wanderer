class_name KeyPickUp
extends PickUp

func _on_body_entered(body: Node2D) -> void:
	if body is Player:
		print("DEBUG: The key is picking up")
		body.key += 1
		self.queue_free()
