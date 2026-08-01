extends Node

enum Key { S, D, J, A, SPACE, ENTER }

signal key_pressed(key: Key)
signal shift_held_changed(is_held: bool)

var shift_held: bool = false

const KEY_MAP := {
	KEY_S: Key.S,
	KEY_D: Key.D,
	KEY_J: Key.J,
	KEY_A: Key.A,
	KEY_SPACE: Key.SPACE,
	KEY_ENTER: Key.ENTER,
}

func _input(event: InputEvent) -> void:
	if event is not InputEventKey:
		return
	if event == null or event.echo:
		return
	if event.keycode == KEY_SHIFT:
		if event.pressed != shift_held:
			shift_held = event.pressed
			shift_held_changed.emit(shift_held)
		return
	if event.pressed and KEY_MAP.has(event.keycode):
		key_pressed.emit(KEY_MAP[event.keycode])
