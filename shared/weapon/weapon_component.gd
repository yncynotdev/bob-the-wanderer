class_name WeaponComponent
extends Sprite2D

signal on_weapon_attacked
signal on_weapon_stop_attacked

@export var weapon_res: WeaponResource
@export var actor: CharacterBody2D

@onready var hitbox = $Hitbox
@onready var hitbox_collision = $Hitbox/CollisionShape2D
@onready var attack_timer = $AttackTimer

var is_attacked: bool = false


func _ready() -> void:
	if !weapon_res:
		return
	else:
		init_weapon()
		calculate_collision()
		hitbox.monitorable = false
		print('DEBUG: WeaponComponent texture - ', weapon_res.texture_item)


func _unhandled_input(event: InputEvent) -> void:
	if event is InputEvent:
		if event.is_action_pressed("attack") and !is_attacked:
			on_weapon_attack()

			is_attacked = true
			on_weapon_attacked.emit()


func init_weapon() -> void:
	texture = weapon_res.weapon_texture
	position = weapon_res.weapon_position
	hitbox_collision.shape = weapon_res.weapon_hitbox_shape
	hitbox_collision.shape.size = weapon_res.weapon_hitbox_size


func on_weapon_attack() -> void:
	self.visible = true
	hitbox.monitorable = true
	attack_timer.start(weapon_res.weapon_attack_duration)


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
