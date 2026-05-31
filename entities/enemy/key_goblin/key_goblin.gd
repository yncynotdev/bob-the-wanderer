class_name KeyGoblin
extends EnemyBase

@export var scatter_target: Array[Spawn]

@onready var marker_piv: Node2D = $MarkerPivot
@onready var marker: Marker2D = $MarkerPivot/Marker2D

@onready var ray_cast: RayCast2D = $RayCast2D

var next_pos: Marker2D


func _ready() -> void:
	current_state = State.IDLE
	init_enemy()

	print('DEBUG: KeyGoblin speed - ', status.base_speed)
	print('DEBUG: KeyGoblin attack - ', status.base_attack)
	print('DEBUG: KeyGoblin defense - ', status.base_defense)
	print('DEBUG: KeyGoblin health - ', health)


func state_idle() -> void:
	next_pos = scatter_target.pick_random()
	await get_tree().create_timer(0.5).timeout

	change_state(State.SCATTER)


func state_scatter(delta: float) -> void:
	animation_direction("move")

	set_movement_target(next_pos.global_position)

	if ray_cast.is_colliding():
		change_state(State.IDLE)

	navigation_logic(delta)
	if navigation_agent_2d.is_target_reached() == true:
		change_state(State.IDLE)

	move_and_slide()

	if is_hit:
		change_state(State.HIT)


func _on_area_detectables_body_entered(body: Node2D) -> void:
	if body is Player:
		change_state(State.IDLE)
