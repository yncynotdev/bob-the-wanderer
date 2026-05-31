class_name EnemyManager
extends Node2D

signal on_enemy_died


func _physics_process(_delta: float) -> void:
	for i in self.get_child_count():
		if i < 3:
			print("DEBUG: We are emitting this")
			on_enemy_died.emit()
