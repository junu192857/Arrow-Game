extends Node

const STAGE_TIME_LIMIT := 15.0

var level: int
var stage: int

var score: int

var playing: bool

var time_left: float = 0.0
var _stage_perfect: bool = true

var _time_bar_anchor_left: float
var _time_bar_full_anchor_right: float

const TARGET_CHATTING_SCENE := preload("res://Prefabs/TargetChatting.tscn")
const RECORD_CHATTING_SCENE := preload("res://Prefabs/record_chatting.tscn")
var target_count

var _target_base_anchor_top: float
var _target_base_anchor_bottom: float
var _target_anchor_step: float
var _target_base_ready: bool = false

var target_chattings: Array[Chatting]
var current_chatting: Chatting
var current_record: Chatting
var _reposition_tween: Tween


func _ready():
	level = 0
	_time_bar_anchor_left = $StatusPanel/TimeBar.anchor_left
	_time_bar_full_anchor_right = $StatusPanel/TimeBar.anchor_right
	$InformationPanel/InformationManager.information_closed.connect(start_new_stage)
	InputManager.key_pressed.connect(_on_key_pressed)
	_update_score_display()
	start_new_level()

func _process(delta: float) -> void:
	if not playing:
		return
	time_left = max(0.0, time_left - delta)
	_update_time_display()
	if time_left <= 0.0:
		_game_over()

func _update_time_display() -> void:
	var fraction := time_left / STAGE_TIME_LIMIT
	$StatusPanel/TimeBar.anchor_right = _time_bar_anchor_left + (_time_bar_full_anchor_right - _time_bar_anchor_left) * fraction
	$StatusPanel/TimeText.text = str(ceili(time_left))

func _update_score_display() -> void:
	$StatusPanel/ScoreValue.text = str(score)

func _game_over() -> void:
	playing = false

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
	time_left = STAGE_TIME_LIMIT
	_stage_perfect = true
	target_chattings.clear()
	for child in $GamePanel.get_children():
		child.queue_free()
	_create_record(_random_line("res://RecordChattings.txt"), _random_target_skill())
	target_count = max(10, level)
	_create_targets(target_count, true)
	_set_current_chatting(target_chattings[0])
	$StatusPanel/LevelValue.text = "Level %d-%d" % [level, stage]
	_update_time_display()

func _on_key_pressed(key: InputManager.Key) -> void:
	if !playing:
		return
	match key:
		InputManager.Key.D:
			_apply_imoji(0)
		InputManager.Key.J:
			_apply_imoji(1)
		InputManager.Key.S:
			_apply_imoji(3)
		InputManager.Key.A:
			_apply_imoji(2)
		InputManager.Key.SPACE:
			_advance_chatting()

func _apply_imoji(imojiIndex: int) -> void:
	if not _is_type_unlocked(imojiIndex):
		return
	if InputManager.shift_held:
		if _can_delete_type(imojiIndex):
			current_chatting.delete_imoji(imojiIndex)
	else:
		_try_add_imoji(imojiIndex)

func _try_add_imoji(imojiIndex: int) -> void:
	var current_count := current_chatting.get_imoji_count(imojiIndex)
	if not _can_delete_type(imojiIndex) and current_count >= _required_count(imojiIndex, current_chatting):
		current_chatting.flash_wrong()
		_stage_perfect = false
		return
	if current_count >= _max_count_for(imojiIndex):
		return
	current_chatting.add_imoji(imojiIndex)

func _is_type_unlocked(imojiIndex: int) -> bool:
	match imojiIndex:
		0:
			return level >= 1
		1:
			return level >= 2
		3:
			return level >= 6
		2:
			return level >= 7
	return false

func _max_count_for(imojiIndex: int) -> int:
	match imojiIndex:
		0, 1:
			return 5 if level >= 8 else 1
		2, 3:
			return 5 if level >= 9 else 1
	return 0

func _can_delete_type(imojiIndex: int) -> bool:
	match imojiIndex:
		0:
			return level >= 3
		1:
			return level >= 4
		2:
			return level >= 7
		3:
			return level >= 6
	return false

func _required_count(imojiIndex: int, chatting: Chatting) -> int:
	match imojiIndex:
		0:
			var diff := chatting.skill - current_record.skill
			return max(0, diff + 1) if level >= 8 else (1 if diff >= 0 else 0)
		1:
			var diff := chatting.skill - current_record.skill
			return max(0, diff) if level >= 8 else (1 if diff > 0 else 0)
		2:
			var idx := target_chattings.find(chatting)
			if idx <= 0:
				return 0
			var diff := target_chattings[idx - 1].skill - chatting.skill
			return max(0, diff + 1) if level >= 9 else (1 if diff >= 0 else 0)
		3:
			var idx := target_chattings.find(chatting)
			if idx < 0 or idx >= target_chattings.size() - 1:
				return 0
			var diff := target_chattings[idx + 1].skill - chatting.skill
			return max(0, diff + 1) if level >= 9 else (1 if diff >= 0 else 0)
	return 0

func _advance_chatting() -> void:
	if not _can_advance_chatting():
		current_chatting.flash_wrong()
		_stage_perfect = false
		return
	current_chatting.flash_correct()
	score += 1
	var next_index := target_chattings.find(current_chatting) + 1
	if next_index >= target_chattings.size():
		var perfect := _stage_perfect
		var time_bonus := ceili(time_left)
		if perfect:
			score += 2
		score += time_bonus
		_update_score_display()
		playing = false
		await _show_stage_clear_labels(perfect, time_bonus)
		if stage >= 3:
			start_new_level()
		else:
			start_new_stage()
		return
	_update_score_display()
	_set_current_chatting(target_chattings[next_index])

func _show_stage_clear_labels(perfect: bool, time_bonus: int) -> void:
	$StageClearLabel.visible = true
	$PerfectLabel.visible = perfect
	$TimeBonusLabel.text = "Time +%d" % time_bonus
	$TimeBonusLabel.visible = true
	await get_tree().create_timer(2.0).timeout
	$StageClearLabel.visible = false
	$PerfectLabel.visible = false
	$TimeBonusLabel.visible = false

func _can_advance_chatting() -> bool:
	for imoji_index in range(4):
		if not _is_type_unlocked(imoji_index):
			continue
		if current_chatting.get_imoji_count(imoji_index) != _required_count(imoji_index, current_chatting):
			return false
	return true

func _set_current_chatting(chatting: Chatting) -> void:
	if current_chatting != null:
		current_chatting.set_highlighted(false)
	current_chatting = chatting
	if current_chatting != null:
		current_chatting.set_highlighted(true)
	_reposition_targets()

func _reposition_targets() -> void:
	var current_index := target_chattings.find(current_chatting)
	if current_index < 0:
		return
	if _reposition_tween != null:
		_reposition_tween.kill()
	_reposition_tween = create_tween()
	_reposition_tween.set_parallel(true)
	for i in range(target_chattings.size()):
		var offset := (i - current_index) * _target_anchor_step
		var target_top := _target_base_anchor_top + offset
		var target_bottom := _target_base_anchor_bottom + offset
		_reposition_tween.tween_property(target_chattings[i], "anchor_top", target_top, 0.3)
		_reposition_tween.tween_property(target_chattings[i], "anchor_bottom", target_bottom, 0.3)

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
	current_record = record

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
	var skills := _generate_target_skills(count)
	for i in range(count):
		var chatting = _create_target(i, skills[i], _random_line("res://Chattings.txt"))
		if ingame:
			target_chattings.append(chatting)

func _random_target_skill() -> Chatting.Skill:
	var pool: Array[Chatting.Skill] = [Chatting.Skill.Demon, Chatting.Skill.Pro, Chatting.Skill.Middleman]
	if level >= 5:
		pool.append(Chatting.Skill.Ranker)
	if level >= 10:
		pool.append(Chatting.Skill.Newbie)
	return pool[randi() % pool.size()]

func _generate_target_skills(count: int) -> Array[Chatting.Skill]:
	var pool: Array[Chatting.Skill] = [Chatting.Skill.Demon, Chatting.Skill.Pro, Chatting.Skill.Middleman]
	if level >= 5:
		pool.append(Chatting.Skill.Ranker)
	if level >= 10:
		pool.append(Chatting.Skill.Newbie)
	var skills: Array[Chatting.Skill] = pool.duplicate()
	while skills.size() < count:
		skills.append(pool[randi() % pool.size()])
	skills.shuffle()
	return skills

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
		2:
			_create_record("와진짜겨우했네요...", Chatting.Skill.Pro)
			_create_target(0, Chatting.Skill.Demon, "츄니즘잘하면좋겠죠..")

func show_information_chatting(p_level: int):
	pass
