extends Node

@onready var label: Label = $Label

var lines: PackedStringArray = []
var line_index: int = -1

func _ready() -> void:
	InputManager.key_pressed.connect(_on_key_pressed)

func show_information(level: int) -> void:
	var text := FileAccess.get_file_as_string("res://Informations/Level%d.txt" % level)
	lines = text.split("\n")
	while lines.size() > 0 and lines[-1].is_empty():
		lines.remove_at(lines.size() - 1)
	line_index = 0
	_show_current_line()

func _on_key_pressed(key: InputManager.Key) -> void:
	if key != InputManager.Key.ENTER or lines.is_empty():
		return
	if line_index >= lines.size() - 1:
		get_parent().visible = false
		lines.clear()
		return
	line_index += 1
	_show_current_line()

func _show_current_line() -> void:
	label.text = lines[line_index]
