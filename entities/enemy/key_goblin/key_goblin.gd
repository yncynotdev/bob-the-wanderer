class_name KeyGoblin
extends EnemyBase

func _ready() -> void:
	init_enemy()


# TODO: Add more polished player avoidance
func state_chase(delta: float) -> void:
	animation_direction("move")

	set_movement_target(-player.global_position)

	navigation_logic(delta)

	# if navigation_agent_2d.avoidance_enabled:
	# 	navigation_agent_2d.set_velocity_forced(direction)
	# else:
	# 	_on_velocity_computed(direction)

	move_and_slide()

	if is_hit:
		change_state(State.HIT)
