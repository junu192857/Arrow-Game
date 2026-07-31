extends Control
class_name Chatting

enum Skill { Newbie, Middleman, Pro, Demon, Ranker }

@export var icon: TextureRect
@export var chat: Label
@export var username: Label
@export var imojiHolders: Array[ImojiManager]
@export var holder_count: int
@export var is_target: bool


var skill: int
var upper_left_arrow: int
var place_of_worship: int
var upper_arrow: int
var down_arrow: int

var is_current: bool = false

func _ready() -> void:
	if is_target:
		for i in range(holder_count):
			imojiHolders[i].clear()
	setup(Skill.Newbie)

func set_highlighted(value: bool) -> void:
	if is_current == value:
		return
	is_current = value
	queue_redraw()

func _draw() -> void:
	if is_current:
		draw_rect(Rect2(Vector2.ZERO, size), Color.LIGHT_SKY_BLUE, false, 4.0)

func setup(p_skill: Skill) -> void:
	skill = p_skill
	match p_skill:
		Skill.Newbie:
			icon.texture = load("res://Textures/DiscordIcons/blue_icon.png")
			username.text = "뉴비"
			username.add_theme_color_override("font_color", Color.WHITE)
		Skill.Middleman:
			icon.texture = load("res://Textures/DiscordIcons/green_icon.png")
			username.text = "미들맨"
			username.add_theme_color_override("font_color", Color.GREEN)
		Skill.Pro:
			icon.texture = load("res://Textures/DiscordIcons/yellow_icon.png")
			username.text = "고수"
			username.add_theme_color_override("font_color", Color.ORANGE)
		Skill.Demon:
			icon.texture = load("res://Textures/DiscordIcons/red_icon.png")
			username.text = "악귀"
			username.add_theme_color_override("font_color", Color.ORANGE_RED)
		Skill.Ranker:
			icon.texture = load("res://Textures/DiscordIcons/orange_icon.png")
			username.text = "탑랭커"
			username.add_theme_color_override("font_color", Color.WEB_PURPLE)

func add_imoji(imojiIndex: int):
	for i in range(holder_count):
		if imojiHolders[i].imoji_index == imojiIndex:
			imojiHolders[i].add_count()
			break
		elif imojiHolders[i].imoji_index == -1:
			imojiHolders[i].assign_imoji(imojiIndex)
			break

func delete_imoji(imojiIndex: int):
	for i in range(holder_count):
		if imojiHolders[i].imoji_index == imojiIndex:
			var cleaned = imojiHolders[i].subtract_count()
			if cleaned:
				for j in range(i, holder_count - 1):
					imojiHolders[j].copy_from(imojiHolders[j + 1])
				imojiHolders[holder_count - 1].clear()
			break
