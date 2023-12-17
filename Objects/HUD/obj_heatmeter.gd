extends Node2D

var sprite = "mild"
var pop = "mildpop"
var idle = "mild"

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35

func _process(delta):
	$Sprite.animation = sprite
	$HeatMeter.value = global.heatstyle
	var obj_camera = utils.get_instance("obj_camera")
	position.x = obj_camera.global_position.x - 480
	position.y = obj_camera.global_position.y - 270
	if ((global.targetRoom == "rank_room" || global.targetRoom == "timesuproom" || global.targetRoom == "Realtitlescreen" || global.targetRoom == "characterselect" || global.targetRoom == "rm_levelselect" || !global.hudvisible) || global.heatstyle <= 0):
		visible = false
	else:
		visible = true
	var obj_player = utils.get_player()
	if (obj_player.global_position.y < (global_position.y + 110) && obj_player.global_position.x < (global_position.x + 240)):
		modulate.a = 0.5
	else:
		modulate.a = 1
	match global.heatstylethreshold:
		0:
			pop = "mildpop"
			idle = "mild"
		1:
			pop = "antsypop"
			idle = "antsy"
		2:
			pop = "madpop"
			idle = "mad"
		3:
			pop = "crazypop"
			idle = "crazy"
	if (global.heatstyle > 55 && global.heatstylethreshold < 3):
		global.heatstylethreshold += 1
		global.heatstyle = (global.heatstyle - 55)
		match global.heatstylethreshold:
			0:
				pop = "mildpop"
				idle = "mild"
			1:
				pop = "antsypop"
				idle = "antsy"
			2:
				pop = "madpop"
				idle = "mad"
			3:
				pop = "crazypop"
				idle = "crazy"
		sprite = pop
		utils.heatup()
	if (global.heatstyle < 0 && global.heatstylethreshold != 0):
		global.heatstylethreshold -= 1
		global.heatstyle = (global.heatstyle + 55)
		match global.heatstylethreshold:
			0:
				pop = "mildpop"
				idle = "mild"
			1:
				pop = "antsypop"
				idle = "antsy"
			2:
				pop = "madpop"
				idle = "mad"
			3:
				pop = "crazypop"
				idle = "crazy"
		sprite = pop
		utils.heatdown()
	if (sprite == pop && $Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1):
		sprite = idle
	if (global.heatstyle < 0 && global.heatstylethreshold == 0):
		global.heatstyle = 0
	if (global.heatstylethreshold == 3 && global.heatstyle > 55):
		global.heatstyle = 55
	
