class_name Player
extends CharacterBody2D

@export var status: Status

@onready var health_component = $HealthComponent

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var hurtbox_collision = $Hurtbox/CollisionShape2D

@onready var hurt_sfx: AudioStreamPlayer2D = $HurtSFX

@onready var knockback_duration: Timer = $KnockbackDuration
@export var knockback_time: float = 2.0
@export var knockback_power: float = 500.0

@onready var weapon_placeholder: Node2D = %WeaponPlaceholder
@onready var weapon: WeaponComponent = weapon_placeholder.get_child(0)

@onready var enemy = get_tree().get_first_node_in_group("enemy")

var health: float
var attack: float
var defense: float
var speed: float

var direction = Vector2.ZERO

enum State {
	IDLE,
	MOVE,
	ATTACK,
	HIT,
	DEAD,
}

var is_attacked: bool = false
var is_attacked_pressed: bool = false

var is_hit: bool = false

var current_state = State.MOVE


func change_state(new_state: State) -> void:
	if new_state == current_state:
		return

	current_state = new_state


func _ready() -> void:
	add_to_group('player')

	if !weapon:
		return
	else:
		weapon.connect('on_weapon_attacked', start_attacking)
		weapon.connect('on_weapon_stop_attacked', stop_attacking)

	health = health_component.health

	attack = status.current_attack

	defense = status.current_defense

	speed = status.current_speed


func _physics_process(_delta: float) -> void:
	match current_state:
		State.IDLE:
			pass
		State.MOVE:
			state_move()
		State.ATTACK:
			state_attack()
		State.HIT:
			state_hit()
		State.DEAD:
			pass


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEvent:
		if event.is_action_pressed("left"):
			direction = Vector2.LEFT
		elif event.is_action_pressed("right"):
			direction = Vector2.RIGHT
		elif event.is_action_pressed("up"):
			direction = Vector2.UP
		elif event.is_action_pressed("down"):
			direction = Vector2.DOWN


func idle() -> void:
	velocity = Vector2.ZERO

	move_and_slide()

	if is_attacked:
		change_state(State.ATTACK)

	if is_hit:
		change_state(State.HIT)


func animation_direction(action: String) -> void:
	match direction:
		Vector2.LEFT:
			sprite.play(str("%s_left" % action))
			weapon_placeholder.position = Vector2(-8.0, 4.0)
			weapon_placeholder.rotation_degrees = 90.0
		Vector2.RIGHT:
			sprite.play(str("%s_right" % action))
			weapon_placeholder.position = Vector2(8.0, 4.0)
			weapon_placeholder.rotation_degrees = 270.0
		Vector2.UP:
			sprite.play(str("%s_up" % action))
			weapon_placeholder.position = Vector2(-3.0, -8.0)
			weapon_placeholder.rotation_degrees = 180.0
		Vector2.DOWN:
			weapon_placeholder.position = Vector2(-3.0, 8.0)
			weapon_placeholder.rotation_degrees = 0.0
			sprite.play(str("%s_down" % action))


func state_move() -> void:
	animation_direction("move")

	velocity = direction * speed

	move_and_slide()

	if is_attacked:
		change_state(State.ATTACK)

	if is_hit:
		change_state(State.HIT)


func state_attack() -> void:
	idle()

	if is_attacked_pressed and is_attacked:
		is_attacked_pressed = false
		animation_direction("attack")

	if !is_attacked:
		change_state(State.MOVE)

	if is_hit:
		change_state(State.HIT)


func start_attacking() -> void:
	is_attacked = true
	is_attacked_pressed = true


func stop_attacking() -> void:
	is_attacked = false
	is_attacked_pressed = false


func state_hit() -> void:
	hurtbox_collision.disabled = true

	animation_direction("hit")

	if !is_hit:
		hurtbox_collision.disabled = false
		change_state(State.MOVE)


func knockback() -> void:
	var knockback_dir: Vector2 = -velocity.normalized() * knockback_power
	velocity = knockback_dir

	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		knockback_duration.start(knockback_time)
		knockback()

		hurt_sfx.play()
		is_hit = true


func _on_knockback_duration_timeout() -> void:
	is_hit = false
