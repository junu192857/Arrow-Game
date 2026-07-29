extends Node
class_name ImojiManager

enum Imoji { UpperLeftArrow, PlaceOfWorship, UpwardArrow, DownwardArrow }

var imoji_index: int = -1
var count: int


func assign_imoji(imoji_index: int):
	if count != 0:
		push_error("Can only assign imoji when nothing in here")
		return
	match imoji_index:
		Imoji.UpperLeftArrow:
			$TextureRect.texture = load("res://Textures/Imojis/upper_left_arrow.png")
		Imoji.PlaceOfWorship:
			$TextureRect.texture = load("res://Textures/Imojis/place_or_worship.png")
		Imoji.UpwardArrow:
			$TextureRect.texture = load("res://Textures/Imojis/upward_arrow.png")
		Imoji.DownwardArrow:
			$TextureRect.texture = load("res://Textures/Imojis/downward_arrow.png")
	count = 1

func add_count():
	if count >= 10:
		return
	count += 1

func subtract_count() -> bool:
	if count <= 0:
		return false
	count -= 1
	if count == 0:
		imoji_index = -1
		return true
	return false
