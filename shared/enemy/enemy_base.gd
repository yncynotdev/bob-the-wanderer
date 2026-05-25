class_name EnemyBase
extends CharacterBody2D

@export var status: Status

@onready var health_component = $HealthComponent
@onready var hitbox = $Hitbox

@onready var sprite = $AnimatedSprite2D

var health: float


func init_enemy() -> void:
	hitbox.set_attacker_status(status)

	print('DEBUG: EnemyBase status - ', status)

	if !health_component:
		return
	else:
		health_component.connect("health_depleted", queue_free)
		health = health_component.health

		print("DEBUG: EnemyBase health component - ", health_component.current_max_health)
		print("DEBUG: EnemyBase health - ", health)


func _physics_process(delta: float) -> void:
	move_and_slide()
