class_name SettingsMenu
extends Control

@export var main_scene: PackedScene
@export var main_menu: MainMenu

@onready var exit_button: Button = get_node("%ExitButton")


func _ready() -> void:
	self.visible = false
	exit_button.visible = false

	if !main_menu:
		exit_button.visible = true
		return

	if !main_scene:
		return


func _unhandled_input(event: InputEvent) -> void:
	if event.is_action_pressed('esc') and !self.visible:
		self.visible = true
	if event.is_action_pressed('esc') and self.visible:
		self.visible = false


func _on_back_button_pressed() -> void:
	self.visible = false

	if main_menu:
		main_menu.visible = true


func _on_exit_button_pressed() -> void:
	get_tree().change_scene_to_packed(main_scene)
