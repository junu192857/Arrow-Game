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
	target_chattings.clear()
	for child in $GamePanel.get_children():
		child.queue_free()
	_create_record(_random_line("res://RecordChattings.txt"), _random_target_skill())
	target_count = max(10, level)
	_create_targets(target_count, true)

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
