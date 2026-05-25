class_name WeaponComponent
extends Sprite2D

signal on_weapon_attacked
signal on_weapon_stop_attacked

@export var weapon_res: WeaponResource
@export var actor: CharacterBody2D

@onready var hitbox = $Hitbox
@onready var hitbox_collision = $Hitbox/CollisionShape2D

@onready var attack_timer = $AttackTimer
@onready var attack_cooldown_timer = $AttackCooldownTimer

var is_attacked: bool = false
var is_attack_cooldown: bool = false


func _ready() -> void:
	if !weapon_res:
		return
	else:
		init_weapon()
		calculate_collision()
		hitbox.monitorable = false


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEvent:
		if event.is_action_pressed("attack") and !is_attacked and !is_attack_cooldown:
			on_weapon_attack()

			is_attacked = true
			is_attack_cooldown = true


func init_weapon() -> void:
	texture = weapon_res.weapon_texture
	position = weapon_res.weapon_position
	hitbox_collision.shape = weapon_res.weapon_hitbox_shape
	hitbox_collision.shape.size = weapon_res.weapon_hitbox_size


func on_weapon_attack() -> void:
	on_weapon_attacked.emit()
	self.visible = true
	hitbox.monitorable = true

	attack_timer.start(weapon_res.weapon_attack_duration)
	attack_cooldown_timer.start(weapon_res.weapon_cooldown_duration + weapon_res.weapon_attack_duration)


func calculate_collision() -> void:
	if actor is Player:
		hitbox.collision_layer = 8
		hitbox.collision_mask = 64

	if actor is EnemyBase:
		hitbox.collision_layer = 16
		hitbox.collision_mask = 32


func _on_attack_timer_timeout() -> void:
	attack_timer.stop()

	self.visible = false
	hitbox.set_deferred("monitorable", false)
	attack_timer.start(weapon_res.weapon_attack_duration)

	is_attacked = false
	on_weapon_stop_attacked.emit()


func _on_attack_cooldown_timer_timeout() -> void:
	is_attacked = false
	is_attack_cooldown = false
