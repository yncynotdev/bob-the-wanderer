class_name HealthComponent
extends Node

signal health_depleted
signal health_changed(current_health: float, max_health: float)

@export var base_max_health: float = 5

var current_max_health: float = base_max_health

var health: float = current_max_health:
	set = on_set_health


func on_set_health(value: float) -> void:
	health = clamp(value, 0, current_max_health)
	health_changed.emit(health, current_max_health)
	if health <= 0:
		health_depleted.emit()
