extends Node
class_name ImojiManager

enum Imoji { UpperLeftArrow, PlaceOfWorship, UpwardArrow, DownwardArrow }

var imoji_index: int = -1
var count: int
@onready var texture_rect: TextureRect = $TextureRect
@onready var label: Label = $Label

func assign_imoji(new_imoji_index: int):
	if count != 0:
		push_error("Can only assign imoji when nothing in here")
		return
	match new_imoji_index:
		Imoji.UpperLeftArrow:
			texture_rect.texture = load("res://Textures/Imojis/upper_left_arrow.png")
		Imoji.PlaceOfWorship:
			texture_rect.texture = load("res://Textures/Imojis/place_or_worship.png")
		Imoji.UpwardArrow:
			texture_rect.texture = load("res://Textures/Imojis/upward_arrow.png")
		Imoji.DownwardArrow:
			texture_rect.texture = load("res://Textures/Imojis/downward_arrow.png")
	add_count()

func add_count():
	if count >= 10:
		return
	count += 1
	label.text = "%d" % count

func subtract_count() -> bool:
	if count <= 0:
		return false
	count -= 1
	if count == 0:
		imoji_index = -1
		texture_rect.texture = null
		label.text = ""
		return true
	label.text = "%d" % count
	return false
