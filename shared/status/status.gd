class_name Status
extends Resource

@export var base_max_attack: float = 5
@export var base_max_defense: float = 5
@export var base_max_speed: float = 100
@export var experience: float = 0:
	set = on_set_experience

var level: float = 0:
	get():
		return floor(max(1.0, sqrt(experience / 100.0) + 0.5))
var current_attack: float = base_max_attack
var current_defense: float = base_max_defense
var current_speed: float = base_max_speed

# func _init() -> void:
# 	init_status.call_deferred()
#
#
# func init_status() -> void:
# 	health = current_max_health

## Setter functions


func on_set_experience(value: float) -> void:
	var old_level: float = level
	experience = value

	if not old_level == level:
		pass
