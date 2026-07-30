extends Control

enum Skill { Newbie, Middleman, Pro, Demon, Ranker }

@export var icon: TextureRect
@export var chat: Label
@export var username: Label
@export var imojiHolders: Array[ImojiManager]
@export var holder_count: int

var skill: int
var upper_left_arrow: int
var place_of_worship: int
var upper_arrow: int
var down_arrow: int

func _ready() -> void:
	InputManager.key_pressed.connect(_on_key_pressed)
	for i in range(holder_count):
		imojiHolders[i].clear()
	setup(Skill.Newbie)

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
