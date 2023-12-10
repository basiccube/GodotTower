extends Node2D

func _process(delta):
	if (!global.stylebar):
		global.style = 0
		global.stylethreshold = 0
		global.multiplier = 1
		visible = false
		return
	var obj_camera = utils.get_instance("obj_camera")
	position.x = obj_camera.global_position.x - 480
	position.y = obj_camera.global_position.y - 270
	if (global.targetRoom == "rank_room" || global.targetRoom == "timesuproom" || global.targetRoom == "Realtitlescreen" || global.targetRoom == "characterselect" || global.targetRoom == "rm_levelselect" || !global.hudvisible):
		visible = false
	else:
		visible = true
	var obj_player = utils.get_player()
	if (obj_player.global_position.y < (global_position.y + 110)):
		modulate.a = 0.5
	else:
		modulate.a = 1
	if (global.style > 55 && global.stylethreshold < 4):
		global.stylethreshold += 1
		global.style = (global.style - 55)
	if (global.style < 0 && global.stylethreshold != 0):
		global.stylethreshold -= 1
		global.style = (global.style + 55)
	if (global.style >= 0 && global.combotime <= 50):
		global.style -= 0.2
	if (global.style < 0 && global.stylethreshold == 0):
		global.style = 0
	if (global.stylethreshold == 4 && global.style > 55):
		global.style = 55
	$Styles.frame = global.stylethreshold
	match global.stylethreshold:
		0:
			global.multiplier = 1
			$Threshold0Fill.value = global.style
			$Threshold1Fill.value = 0
			$Threshold2Fill.value = 0
			$Threshold3Fill.value = 0
			$Threshold4Fill.value = 0
		1:
			global.multiplier = 2
			$Threshold0Fill.value = 55
			$Threshold1Fill.value = global.style
			$Threshold2Fill.value = 0
			$Threshold3Fill.value = 0
			$Threshold4Fill.value = 0
		2:
			global.multiplier = 3
			$Threshold0Fill.value = 55
			$Threshold1Fill.value = 55
			$Threshold2Fill.value = global.style
			$Threshold3Fill.value = 0
			$Threshold4Fill.value = 0
		3:
			global.multiplier = 4
			$Threshold0Fill.value = 55
			$Threshold1Fill.value = 55
			$Threshold2Fill.value = 55
			$Threshold3Fill.value = global.style
			$Threshold4Fill.value = 0
		4:
			global.multiplier = 5
			$Threshold0Fill.value = 55
			$Threshold1Fill.value = 55
			$Threshold2Fill.value = 55
			$Threshold3Fill.value = 55
			$Threshold4Fill.value = global.style
