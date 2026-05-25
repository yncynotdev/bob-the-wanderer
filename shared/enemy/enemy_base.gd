class_name EnemyBase
extends CharacterBody2D

@export var status: Status
@onready var health_component = $HealthComponent

var health: float


func _ready() -> void:
	health_component.connect("health_depleted", queue_free)
	health = health_component.health
	print("DEBUG: EnemyBase healht - ", health)


func _physics_process(delta: float) -> void:
	move_and_slide()


func _on_hurtbox_area_entered(area: Area2D) -> void:
	if area is Hitbox:
		print('DEBUG: Fuck you player')
