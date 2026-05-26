class_name Hitbox
extends AreaDetectables

var attacker_status: Status:
	set = set_attacker_status


func set_attacker_status(value) -> void:
	attacker_status = value


var weapon_damage: float = 0:
	set = set_weapon_damage


func set_weapon_damage(value) -> void:
	weapon_damage = value


func _on_area_entered(area: Area2D) -> void:
	if not area.has_method('receive_damage'):
		return

	if area is Hurtbox:
		area.receive_damage(attacker_status.current_attack + weapon_damage)
