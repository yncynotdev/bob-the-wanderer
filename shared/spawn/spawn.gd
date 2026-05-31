class_name Spawn
extends Marker2D

@export var enemy: PackedScene
@export var enemy_manager: EnemyManager

@onready var spawn_timer: Timer = $SpawnTimer
@export var spawn_timer_time: float = 3.0

@onready var idle_timer: Timer = $SpawnTimer
@export var idle_timer_time: float = 3.0


func _ready() -> void:
	enemy_manager.connect('on_enemy_died', spawn_timer.start.bind(spawn_timer_time))
	spawn_timer.start(spawn_timer_time)


func spawn_enemy() -> void:
	print('DEBUG: Its spawning time')

	var enemy_instance = enemy.instantiate()

	enemy_instance.global_position = self.position

	enemy_manager.add_child(enemy_instance)


func _on_spawn_timer_timeout() -> void:
	spawn_enemy()
