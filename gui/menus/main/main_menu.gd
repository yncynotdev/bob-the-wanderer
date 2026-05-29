class_name MainMenu
extends Control

@export var starting_scene: PackedScene
@export var settings_menu: SettingsMenu


func _on_exit_button_pressed() -> void:
	get_tree().quit()


func _on_settings_button_pressed() -> void:
	self.visible = false
	settings_menu.visible = true


# TODO: Add a loading scene later
func _on_start_button_pressed() -> void:
	get_tree().change_scene_to_packed(starting_scene)
