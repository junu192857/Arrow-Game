extends Panel

func set_skill_guide(level: int):
	$Ranker.visible = true if level >= 10 else false
	$Demon.visible = true
	$Pro.visible = true
	$Middleman.visible = true
	$Newbie.visible = true if level >= 5 else false
