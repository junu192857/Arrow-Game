extends Control

enum Skill { Newbie, Middleman, Pro, Demon, Ranker }

@export var icon: TextureRect
@export var chat: Label
@export var username: Label
@export var imojiHolders: Array[ImojiManager]

var skill: int
var upper_left_arrow: int
var place_of_worship: int
var upper_arrow: int
var down_arrow: int

func _ready() -> void:
	InputManager.key_pressed.connect(_on_key_pressed)

func _on_key_pressed(key: InputManager.Key) -> void:
	var imojiIndex: int
	match key:
		InputManager.Key.D:
			imojiIndex = 0
		InputManager.Key.J:
			imojiIndex = 1
		InputManager.Key.S:
			imojiIndex = 2
		InputManager.Key.K:
			imojiIndex = 3
		_:
			return
	if InputManager.shift_held:
		delete_imoji(imojiIndex)
	else:
		add_imoji(imojiIndex)

func setup(p_skill: Skill) -> void:
	skill = p_skill
	match p_skill:
		Skill.Newbie:
			icon.texture = load("res://Textures/DiscordIcons/blue_icon.png")
			chat.text = "뉴비"
			chat.add_theme_color_override("font_color", Color.WHITE)
		Skill.Middleman:
			icon.texture = load("res://Textures/DiscordIcons/green_icon.png")
			chat.text = "미들맨"
			chat.add_theme_color_override("font_color", Color.GREEN)
		Skill.Pro:
			icon.texture = load("res://Textures/DiscordIcons/yellow_icon.png")
			chat.text = "고수"
			chat.add_theme_color_override("font_color", Color.ORANGE)
		Skill.Demon:
			icon.texture = load("res://Textures/DiscordIcons/orange_icon.png")
			chat.text = "악귀"
			chat.add_theme_color_override("font_color", Color.ORANGE_RED)
		Skill.Ranker:
			icon.texture = load("res://Textures/DiscordIcons/red_icon.png")
			chat.text = "탑랭커"
			chat.add_theme_color_override("font_color", Color.WEB_PURPLE)

func add_imoji(imojiIndex: int):
	for i in range(4):
		if imojiHolders[i].imoji_index == imojiIndex:
			imojiHolders[i].add_count()
			break
		elif imojiHolders[i].imoji_index == -1:
			imojiHolders[i].assign_imoji(imojiIndex)
			break

func delete_imoji(imojiIndex: int):
	for i in range(4):
		if imojiHolders[i].imoji_index == imojiIndex:
			var cleaned = imojiHolders[i].subtract_count()
			if cleaned:
				for j in range(i, 3):
					imojiHolders[j].copy_from(imojiHolders[j + 1])
					imojiHolders[3].clear()
			break
