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

func _unhandled_key_input(event: InputEvent) -> void:
	var key_event := event as InputEventKey
	if key_event == null or key_event.echo:
		return
	if key_event.keycode == KEY_SHIFT:
		if key_event.pressed != shift_held:
			shift_held = key_event.pressed
			shift_held_changed.emit(shift_held)
		return
	if key_event.pressed and KEY_MAP.has(key_event.keycode):
		key_pressed.emit(KEY_MAP[key_event.keycode])
