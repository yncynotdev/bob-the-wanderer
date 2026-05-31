class_name EnemyBase
extends CharacterBody2D

@export var status: Status

@export var knockback_power: float = 500.0

@onready var health_component = $HealthComponent

@onready var hitbox = $Hitbox

@onready var sprite = $AnimatedSprite2D
@onready var hit_fx = $HitFX

@onready var hurt_sfx: AudioStreamPlayer2D = $HurtSFX

@onready var player = get_tree().get_first_node_in_group("player")

var direction: Vector2

var health: float

enum State {
	IDLE,
	MOVE,
	HIT,
}

var is_hit: bool = false

var current_state = State.MOVE


func change_state(new_state: State) -> void:
	if new_state == current_state:
		return

	current_state = new_state


func _ready() -> void:
	init_enemy()


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
	direction = Vector2.LEFT

	velocity = direction * status.current_speed
	animation_direction("move")

	move_and_slide()

	if is_hit:
		change_state(State.HIT)


func state_hit() -> void:
	if !is_hit:
		change_state(State.MOVE)


func animation_direction(action: String) -> void:
	match direction:
		Vector2.LEFT:
			sprite.play(str("%s_left" % action))
		Vector2.RIGHT:
			sprite.play(str("%s_right" % action))
		Vector2.UP:
			sprite.play(str("%s_up" % action))
		Vector2.DOWN:
			sprite.play(str("%s_down" % action))


func knockback() -> void:
	var knockback_dir: Vector2 = (player.velocity - velocity).normalized() * knockback_power
	velocity = knockback_dir

	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		knockback()
		is_hit = true
		hit_fx.play('cut')
		hurt_sfx.play()
		hit_fx.visible = true


func _on_hit_fx_animation_finished() -> void:
	if hit_fx.animation == 'cut':
		# hit_fx.visible = false
		hit_fx.set_deferred("visible", false)
