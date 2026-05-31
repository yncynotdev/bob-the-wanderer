class_name EnemyBase
extends CharacterBody2D

@export var status: Status

@export var loot: Loot

@export var can_knockback: bool = true
@export var knockback_power: float = 500.0

@onready var health_component = $HealthComponent

@onready var collision = $CollisionShape2D

@onready var hitbox = $Hitbox
@onready var hitbox_collision = $Hitbox/CollisionShape2D

@onready var hurtbox_collision = $Hurtbox/CollisionShape2D

@onready var sprite = $AnimatedSprite2D

@onready var hit_fx = $HitFX

@onready var hurt_sfx: AudioStreamPlayer2D = $HurtSFX

@onready var hurt_duration: Timer = $HurtDuration
@export var hurt_duration_time: float = 2.0

@onready var player = get_tree().get_first_node_in_group("player")

var direction: Vector2

var health: float

enum State {
	IDLE,
	MOVE,
	HIT,
	DEAD,
}

var is_hit: bool = false

var current_state = State.IDLE


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
		State.DEAD:
			state_dead()


func init_enemy() -> void:
	hitbox.set_attacker_status(status)

	if !health_component:
		return
	else:
		health_component.connect("health_depleted", change_state.bind(State.DEAD))
		health_component.connect("health_depleted", call_deferred.bind('instantiate_loot'))
		health = health_component.health


func state_idle() -> void:
	velocity = Vector2.ZERO

	animation_direction('idle')

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
	hurtbox_collision.disabled = true

	animation_direction('idle')

	if !is_hit:
		hurtbox_collision.disabled = false
		change_state(State.IDLE)


func state_dead() -> void:
	sprite.visible = false

	collision.disabled = true
	hurtbox_collision.disabled = true
	hitbox_collision.disabled = true


func instantiate_loot() -> void:
	print('DEBUG: I spew the loot')
	var _loot = loot.loot_scene.instantiate()
	self.add_child(_loot)


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
		if can_knockback:
			knockback()
		hurt_duration.start(hurt_duration_time)

		is_hit = true

		hit_fx.play('cut')
		hit_fx.visible = true

		hurt_sfx.play()


func _on_hit_fx_animation_finished() -> void:
	if hit_fx.animation == 'cut':
		hit_fx.set_deferred("visible", false)


func _on_hurt_duration_timeout() -> void:
	is_hit = false
