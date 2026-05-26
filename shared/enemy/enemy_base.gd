class_name EnemyBase
extends CharacterBody2D

@export var status: Status

@export var knockback_power: float = 500.0

@onready var health_component = $HealthComponent

@onready var hitbox = $Hitbox

@onready var sprite = $AnimatedSprite2D

@onready var player = get_tree().get_first_node_in_group("player")

var health: float

enum State {
	IDLE,
	MOVE,
	HIT,
}

var is_hit: bool = false

var current_state = State.IDLE


func change_state(new_state: State) -> void:
	if new_state == current_state:
		return

	current_state = new_state


func _physics_process(_delta: float) -> void:
	match current_state:
		State.IDLE:
			state_idle()
		State.MOVE:
			state_move()
		State.HIT:
			state_hit()


func init_enemy() -> void:
	hitbox.set_attacker_status(status)

	if !health_component:
		return
	else:
		health_component.connect("health_depleted", queue_free)
		health = health_component.health


func state_idle() -> void:
	velocity = Vector2.ZERO

	move_and_slide()

	if is_hit:
		change_state(State.HIT)


func state_move() -> void:
	velocity.x = -1 * status.current_speed

	move_and_slide()

	if is_hit:
		change_state(State.HIT)


func state_hit() -> void:
	if !is_hit:
		change_state(State.MOVE)


func knockback() -> void:
	var knockback_dir: Vector2 = (player.velocity - velocity).normalized() * knockback_power
	velocity = knockback_dir

	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		knockback()
		is_hit = true
