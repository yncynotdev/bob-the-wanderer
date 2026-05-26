class_name Hurtbox
extends AreaDetectables

@export var health_component: HealthComponent


func receive_damage(damage: int) -> void:
	health_component.health -= damage


func _on_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		print('DEBUG: Hurtbox detects Hitbox')
