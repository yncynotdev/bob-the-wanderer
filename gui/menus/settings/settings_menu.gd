class_name SettingsMenu
extends Control

@export var main_menu: MainMenu


func _ready() -> void:
	self.visible = false

	if !main_menu:
		return


func _on_back_button_pressed() -> void:
	self.visible = false

	if main_menu:
		main_menu.visible = true
