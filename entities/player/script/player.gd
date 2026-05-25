class_name Player
extends CharacterBody2D

@export var status: Status
@onready var health_component = $HealthComponent

@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D
@onready var weapon_placeholder: Node2D = %WeaponPlaceholder
@onready var weapon: WeaponComponent = weapon_placeholder.get_child(0)

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

var current_state = State.MOVE


func change_state(new_state: State) -> void:
	if new_state == current_state:
		return

	current_state = new_state
	print('DEBUG: State ', current_state)


func _ready() -> void:
	if !weapon:
		return
	else:
		weapon.connect('on_weapon_attacked', start_attacking)
		weapon.connect('on_weapon_stop_attacked', stop_attacking)

	health = health_component.health
	print('DEBUG: Player health ', health)

	attack = status.current_attack
	print('DEBUG: Player attack ', attack)

	defense = status.current_defense
	print('DEBUG: Player defense ', defense)

	speed = status.current_speed
	print('DEBUG: Player speed ', speed)


func _physics_process(_delta: float) -> void:
	match current_state:
		State.IDLE:
			pass
		State.MOVE:
			state_move()
		State.ATTACK:
			state_attack()
		State.HIT:
			pass
		State.DEAD:
			pass

	move_and_slide()


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
	if is_attacked:
		change_state(State.ATTACK)


func move_animation() -> void:
	match direction:
		Vector2.LEFT:
			sprite.play("move_left")
			weapon_placeholder.position = Vector2(-8.0, 4.0)
			weapon_placeholder.rotation_degrees = 90.0
		Vector2.RIGHT:
			sprite.play("move_right")
			weapon_placeholder.position = Vector2(8.0, 4.0)
			weapon_placeholder.rotation_degrees = 270.0
		Vector2.UP:
			sprite.play("move_up")
			weapon_placeholder.position = Vector2(-3.0, -8.0)
			weapon_placeholder.rotation_degrees = 180.0
		Vector2.DOWN:
			sprite.play("move_down")
			weapon_placeholder.position = Vector2(-3.0, 8.0)
			weapon_placeholder.rotation_degrees = 0.0


func state_move() -> void:
	move_animation()
	velocity = direction * speed

	if is_attacked:
		change_state(State.ATTACK)


func attack_animation() -> void:
	match direction:
		Vector2.LEFT:
			sprite.play("attack_left")
		Vector2.RIGHT:
			sprite.play("attack_right")
		Vector2.UP:
			sprite.play("attack_up")
		Vector2.DOWN:
			sprite.play("attack_down")


func state_attack() -> void:
	idle()

	if is_attacked_pressed and is_attacked:
		is_attacked_pressed = false
		attack_animation()

	if !is_attacked:
		change_state(State.MOVE)


func start_attacking() -> void:
	is_attacked = true
	is_attacked_pressed = true


func stop_attacking() -> void:
	is_attacked = false
	is_attacked_pressed = false


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		print('DEBUG: Player ouch')
