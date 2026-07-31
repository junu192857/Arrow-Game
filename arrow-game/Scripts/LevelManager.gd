extends Node

var level: int
var stage: int

var score: int

var playing: bool

const TARGET_CHATTING_SCENE := preload("res://Prefabs/TargetChatting.tscn")
const RECORD_CHATTING_SCENE := preload("res://Prefabs/record_chatting.tscn")
var target_count

var _target_base_anchor_top: float
var _target_base_anchor_bottom: float
var _target_anchor_step: float
var _target_base_ready: bool = false

var target_chattings: Array[Chatting]
var current_chatting: Chatting


func _ready():
	level = 0
	$InformationPanel/InformationManager.information_closed.connect(start_new_stage)
	InputManager.key_pressed.connect(_on_key_pressed)
	start_new_level()

func start_new_level():
	level += 1
	stage = 0
	playing = false
	$GuidePanel.set_guide(level)
	$SkillPanel.set_skill_guide(level)
	$InformationPanel.visible = true
	$InformationPanel/InformationManager.show_information(level)
	show_information_record(level)
	show_information_chatting(level)

func start_new_stage():
	stage += 1
	playing = true
	target_chattings.clear()
	for child in $GamePanel.get_children():
		child.queue_free()
	_create_record(_random_line("res://RecordChattings.txt"), _random_target_skill())
	target_count = max(10, level)
	_create_targets(target_count, true)
	_set_current_chatting(target_chattings[0])

func _on_key_pressed(key: InputManager.Key) -> void:
	if !playing:
		return
	match key:
		InputManager.Key.D:
			_apply_imoji(0)
		InputManager.Key.J:
			_apply_imoji(1)
		InputManager.Key.S:
			_apply_imoji(2)
		InputManager.Key.K:
			_apply_imoji(3)
		InputManager.Key.SPACE:
			_advance_chatting()

func _apply_imoji(imojiIndex: int) -> void:
	if InputManager.shift_held:
		current_chatting.delete_imoji(imojiIndex)
	else:
		current_chatting.add_imoji(imojiIndex)

func _advance_chatting() -> void:
	if not _can_advance_chatting():
		return
	var next_index := target_chattings.find(current_chatting) + 1
	if next_index >= target_chattings.size():
		if stage >= 3:
			start_new_level()
		else:
			start_new_stage()
		return
	_set_current_chatting(target_chattings[next_index])

func _can_advance_chatting() -> bool:
	return true # 조건 추가 예정

func _set_current_chatting(chatting: Chatting) -> void:
	if current_chatting != null:
		current_chatting.set_highlighted(false)
	current_chatting = chatting
	if current_chatting != null:
		current_chatting.set_highlighted(true)

func _create_record(chat_text: String, skill: Chatting.Skill) -> void:
	var record := RECORD_CHATTING_SCENE.instantiate() as Chatting
	$GamePanel.add_child(record)
	record.anchor_left = 0.05
	record.anchor_top = 0.074
	record.anchor_right = 0.291
	record.anchor_bottom = 0.372
	record.offset_left = 0.0
	record.offset_top = 0.08000183
	record.offset_right = -0.631958
	record.offset_bottom = 0.5359802
	record.chat.text = chat_text#_random_line("res://RecordChattings.txt")
	record.setup(skill)
	
func _create_target(index: int, skill: Chatting.Skill, chat_text: String) -> Chatting:
	var target := TARGET_CHATTING_SCENE.instantiate() as Chatting
	$GamePanel.add_child(target)
	if not _target_base_ready:
		_target_base_anchor_top = target.anchor_top
		_target_base_anchor_bottom = target.anchor_bottom
		_target_anchor_step = _target_base_anchor_bottom - _target_base_anchor_top
		_target_base_ready = true
	target.anchor_top = _target_base_anchor_top + index * _target_anchor_step
	target.anchor_bottom = _target_base_anchor_bottom + index * _target_anchor_step
	target.setup(skill)
	target.chat.text = chat_text
	return target

func _create_targets(count: int, ingame: bool) -> void:
	for i in range(count):
		var chatting = _create_target(i, _random_target_skill(), _random_line("res://Chattings.txt"))
		if ingame:
			target_chattings.append(chatting)

func _random_target_skill() -> Chatting.Skill:
	var pool: Array[Chatting.Skill] = [Chatting.Skill.Demon, Chatting.Skill.Pro, Chatting.Skill.Middleman]
	if level >= 5:
		pool.append(Chatting.Skill.Ranker)
	if level >= 10:
		pool.append(Chatting.Skill.Newbie)
	return pool[randi() % pool.size()]

func _random_line(path: String) -> String:
	var text := FileAccess.get_file_as_string(path)
	var lines := text.split("\n")
	while lines.size() > 0 and lines[-1].is_empty():
		lines.remove_at(lines.size() - 1)
	print(lines.size())
	return lines[randi() % lines.size()]


func show_information_record(p_level: int):
	match p_level:
		1:
			_create_record("오늘성과요~~", Chatting.Skill.Middleman)
			_create_target(0, Chatting.Skill.Pro, "츄니즘잘하면좋겠죠..")

func show_information_chatting(p_level: int):
	pass
