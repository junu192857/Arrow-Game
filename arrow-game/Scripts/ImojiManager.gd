extends Node
class_name ImojiManager

enum Imoji { UpperLeftArrow, PlaceOfWorship, UpwardArrow, DownwardArrow }

var imoji_index: int = -1
var count: int
var texture
var label

func _ready():
	texture = $TextureRect.texture
	label = $Label

func assign_imoji(imoji_index: int):
	if count != 0:
		push_error("Can only assign imoji when nothing in here")
		return
	match imoji_index:
		Imoji.UpperLeftArrow:
			texture = load("res://Textures/Imojis/upper_left_arrow.png")
		Imoji.PlaceOfWorship:
			texture = load("res://Textures/Imojis/place_or_worship.png")
		Imoji.UpwardArrow:
			texture = load("res://Textures/Imojis/upward_arrow.png")
		Imoji.DownwardArrow:
			texture = load("res://Textures/Imojis/downward_arrow.png")
	count = 1

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
		texture = null
		label.text = ""
		return true
	label.text = "%d" % count
	return false
