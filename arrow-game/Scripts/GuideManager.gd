extends Panel

func set_guide(level: int):
	$UpperLeftArrow.visible = true
	$PlaceOfWorship.visible = true if level >= 2 else false
	$UpwardArrow.visible = true if level >= 7 else false
	$DownwardArrow.visible = true if level >= 6 else false
	$Pass.visible = true
	$Delete.visible = true if level >= 3 else false
	
