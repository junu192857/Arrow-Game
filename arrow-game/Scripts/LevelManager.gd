extends Node

var level: int
var stage: int

var score: int

var playing: bool

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
