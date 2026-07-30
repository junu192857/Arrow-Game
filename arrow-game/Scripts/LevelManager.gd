extends Node

var level: int
var stage: int

var score: int

var playing: bool

const TARGET_CHATTING_SCENE := preload("res://Prefabs/TargetChatting.tscn")
const RECORD_CHATTING_SCENE := preload("res://Prefabs/record_chatting.tscn")
var target_count

func _ready():
	level = 0
	start_new_level()

func start_new_level():
	level += 1
	stage = 0
	playing = false
	$GuidePanel.set_guide(level)
	$SkillPanel.set_skill_guide(level)
	$InformationPanel.visible = true
	$InformationPanel/InformationManager.show_information(level)
	start_new_stage()

func start_new_stage():
	stage += 1
	for child in $GamePanel.get_children():
		child.queue_free()

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

	var base_anchor_top: float
	var base_anchor_bottom: float
	var anchor_step: float
	
	target_count = max(10, level)
	
	for i in range(target_count):
		var target := TARGET_CHATTING_SCENE.instantiate() as Chatting
		$GamePanel.add_child(target)
		if i == 0:
			base_anchor_top = target.anchor_top
			base_anchor_bottom = target.anchor_bottom
			anchor_step = base_anchor_bottom - base_anchor_top
		else:
			target.anchor_top = base_anchor_top + i * anchor_step
			target.anchor_bottom = base_anchor_bottom + i * anchor_step
		target.setup(_random_target_skill())

func _random_target_skill() -> Chatting.Skill:
	var pool: Array[Chatting.Skill] = [Chatting.Skill.Demon, Chatting.Skill.Pro, Chatting.Skill.Middleman]
	if level >= 5:
		pool.append(Chatting.Skill.Ranker)
	if level >= 10:
		pool.append(Chatting.Skill.Newbie)
	return pool[randi() % pool.size()]
