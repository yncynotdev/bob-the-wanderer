class_name Player
extends CharacterBody2D

@export var speed: float = 300.0
@onready var sprite: AnimatedSprite2D = $AnimatedSprite2D

@onready var attack_duration: Timer = $AttackDuration
@export var attack_duration_time: float = 1.0

var direction = Vector2.ZERO

enum State {
	IDLE,
	MOVE,
	ATTACK,
	HIT,
	DEAD,
}

var current_state = State.MOVE


func change_state(new_state: State) -> void:
	if new_state == current_state:
		return

	current_state = new_state


func _physics_process(_delta: float) -> void:
	match current_state:
		State.IDLE:
			pass
		State.MOVE:
			move()
		State.ATTACK:
			attack()
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
		elif event.is_action_pressed("attack"):
			attack_duration.start(attack_duration_time)
			attack_animation()
			change_state(State.ATTACK)


func idle() -> void:
	velocity = Vector2.ZERO


func move_animation() -> void:
	match direction:
		Vector2.LEFT:
			sprite.play("move_left")
		Vector2.RIGHT:
			sprite.play("move_right")
		Vector2.UP:
			sprite.play("move_up")
		Vector2.DOWN:
			sprite.play("move_down")


func move() -> void:
	move_animation()
	velocity = direction * speed


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


func attack() -> void:
	idle()
	print("DEBUG: ", attack_duration.time_left)

	if attack_duration.is_stopped():
		change_state(State.MOVE)


func _on_attack_duration_timeout() -> void:
	pass
