extends Node2D

var chose = false
var message = ""
var showtext = false
var tvsprite = "default"
var imageindexstore = 0
var once = false
var shownranka = false
var shownrankb = false
var shownrankc = false
var character = "PEPPINO"
var combo_state = 0
var combo_vsp = 0
var combo_posX = 0
var combo_posY = 0
onready var sprite = $TVSprite
onready var resettimer = $ResetTimer

func _process(delta):
	$MessageLabel.text = message
	$TVSprite.animation = tvsprite
	$TVSprite.playing = true
	$ComboBubble.modulate.a = $TVSprite.modulate.a
	$ScoreLabel.modulate.a = $TVSprite.modulate.a
	var obj_camera = utils.get_instance("obj_camera")
	position.x = obj_camera.global_position.x
	position.y = obj_camera.global_position.y
	if (global.combo != 0 && global.combotime != 0):
		$ComboBubble/ComboLabel.text = str(global.combo)
	if (global.combo != 0 && global.combotime <= 1):
		if (global.combo <= 8):
			imageindexstore = 0
		if (global.combo > 8 && global.combo <= 16):
			imageindexstore = 1
		if (global.combo > 16 && global.combo <= 32):
			imageindexstore = 2
		if (global.combo > 32):
			imageindexstore = 3
		tvsprite = "comboresult"
		$TVSprite.speed_scale = 0
		$TVSprite.frame = imageindexstore
		$ResetTimer.wait_time = 0.83
		$ResetTimer.start()
	if (tvsprite == "default"):
		chose = false
		$ScoreLabel.visible = true
		$ScoreLabel.text = str(global.collect)
	else:
		$ScoreLabel.visible = false
	if (global.targetRoom == "rank_room" || global.targetRoom == "timesuproom" || global.targetRoom == "Realtitlescreen" || global.targetRoom == "characterselect" || global.targetRoom == "rm_levelselect" || !global.hudvisible):
		$TVSprite.modulate.a = 0
	match global.targetRoom:
		"entrance_1":
			global.srank = 13500
			global.arank = (global.srank - (global.srank / 4))
			global.brank = (global.srank - ((global.srank / 4) * 2))
			global.crank = (global.srank - ((global.srank / 4) * 3))
		"medieval_1":
			global.srank = 14000
			global.arank = (global.srank - (global.srank / 4))
			global.brank = (global.srank - ((global.srank / 4) * 2))
			global.crank = (global.srank - ((global.srank / 4) * 3))
		"ruin_1":
			global.srank = 11600
			global.arank = (global.srank - (global.srank / 4))
			global.brank = (global.srank - ((global.srank / 4) * 2))
			global.crank = (global.srank - ((global.srank / 4) * 3))
		"dungeon_1":
			global.srank = 10400
			global.arank = (global.srank - (global.srank / 4))
			global.brank = (global.srank - ((global.srank / 4) * 2))
			global.crank = (global.srank - ((global.srank / 4) * 3))
		"chateau_1":
			global.srank = 11000
			global.arank = (global.srank - (global.srank / 4))
			global.brank = (global.srank - ((global.srank / 4) * 2))
			global.crank = (global.srank - ((global.srank / 4) * 3))
		"trickytreat_2":
			global.srank = 3000
			global.arank = (global.srank - (global.srank / 4))
			global.brank = (global.srank - ((global.srank / 4) * 2))
			global.crank = (global.srank - ((global.srank / 4) * 3))
		"testroom_1":
			global.srank = 4500
			global.arank = (global.srank - (global.srank / 4))
			global.brank = (global.srank - ((global.srank / 4) * 2))
			global.crank = (global.srank - ((global.srank / 4) * 3))
	if (showtext):
		$MessageLabel.rect_position.x = (-480 + utils.randi_range(-1, 1))
		if ($MessageLabel.rect_position.y > 230):
			$MessageLabel.rect_position.y -= 5
	elif (!showtext):
		$MessageLabel.rect_position.x = (-480 + utils.randi_range(-1, 1))
		if ($MessageLabel.rect_position.y < 330):
			$MessageLabel.rect_position.y += 1
	var obj_player = utils.get_player()
	if (!(obj_player.state == global.states.knightpep && obj_player.state == global.states.knightpepattack && obj_player.state == global.states.knightpepslopes)):
		once = false
	if (obj_player.global_position.y < (global_position.y - 110) && obj_player.global_position.x > (global_position.x + 230)):
		$TVSprite.modulate.a = 0.5
	elif (!(global.targetRoom == "rank_room" || global.targetRoom == "timesuproom" || global.targetRoom == "Realtitlescreen" || global.targetRoom == "characterselect" || global.targetRoom == "rm_levelselect" || !global.hudvisible)):
		$TVSprite.modulate.a = 1
	if (utils.instance_exists("obj_itspizzatime")):
		$TVSprite.speed_scale = 0.25
		message = "GET TO THE EXIT!!"
		$ResetTimer.wait_time = 3.33
		$ResetTimer.start()
		showtext = true
		tvsprite = "exit"
	elif (global.collect > global.arank && !shownranka && !global.timeattack):
		$TVSprite.speed_scale = 0
		message = "YOU GOT ENOUGH FOR RANK A"
		showtext = true
		$ResetTimer.wait_time = 3.33
		$ResetTimer.start()
		tvsprite = "ranka"
		shownranka = true
	elif (global.collect > global.brank && !shownrankb && !global.timeattack):
		$TVSprite.speed_scale = 0
		message = "YOU GOT ENOUGH FOR RANK B"
		showtext = true
		$ResetTimer.wait_time = 3.33
		$ResetTimer.start()
		tvsprite = "rankb"
		shownrankb = true
	elif (global.collect > global.crank && !shownrankc && !global.timeattack):
		$TVSprite.speed_scale = 0
		message = "YOU GOT ENOUGH FOR RANK C"
		showtext = true
		$ResetTimer.wait_time = 3.33
		$ResetTimer.start()
		tvsprite = "rankc"
		shownrankc = true
	elif (obj_player.sprite_index == "levelcomplete"):
		$TVSprite.speed_scale = 0.1
		$ResetTimer.wait_time = 0.83
		$ResetTimer.start()
		chose = true
		tvsprite = "clap"
		once = true
	elif (obj_player.state == global.states.hurt):
		$TVSprite.speed_scale = 0.1
		showtext = true
		if (!chose):
			var rng = utils.randi_range(1,4)
			if (rng == 1):
				message = "OW!"
			elif (rng == 2):
				message = "OUCH!"
			elif (rng == 3):
				message = "OH!"
			elif (rng == 4):
				message = "WOH!"
		$ResetTimer.wait_time = 0.83
		$ResetTimer.start()
		chose = true
		tvsprite = "hurt"
		once = true
	elif (obj_player.state == global.states.timesup):
		$ResetTimer.wait_time = 0.83
		$ResetTimer.start()
		$TVSprite.speed_scale = 0.1
		tvsprite = "skull"
	elif (global.hurtcounter > global.hurtmilestone):
		$ResetTimer.wait_time = 2.5
		$ResetTimer.start()
		$TVSprite.speed_scale = 0.1
		if (obj_player.character == "P"):
			character = "PEPPINO"
		elif (obj_player.character == "N"):
			character = "THE NOISE"
		message = "YOU HAVE HURT " + character + " " + str(global.hurtmilestone) + " TIMES..."
		if (tvsprite != "talking1" && tvsprite != "talking2" && tvsprite != "talking3" && tvsprite != "talking4"):
			var rng = utils.randi_range(1,4)
			if (rng == 1):
				tvsprite = "talking1"
			elif (rng == 2):
				tvsprite = "talking2"
			elif (rng == 3):
				tvsprite = "talking3"
			elif (rng == 4):
				tvsprite = "talking4"
		global.hurtmilestone += 3
	elif (obj_player.state == global.states.skateboard):
		showtext = true
		message = "SWEET DUDE!!"
		$ResetTimer.wait_time = 0.83
		$ResetTimer.start()
		tvsprite = "rad"
		once = true
	elif (obj_player.state == global.states.slipnslide):
		$TVSprite.speed_scale = 0.1
		showtext = true
		message = "OOPS!!"
		$ResetTimer.wait_time = 0.83
		$ResetTimer.start()
		tvsprite = "banana"
		once = true
	elif (global.targetRoom == "Realtitlescreen"):
		$TVSprite.speed_scale = 0.1
		tvsprite = "banana"
		$ResetTimer.wait_time = 0.1
		$ResetTimer.start()
		if (utils.instance_exists_level("obj_mainmenuselect")):
			var obj_mainmenuselect = utils.get_instance_level("obj_mainmenuselect")
			if (!obj_mainmenuselect.selected):
				if (obj_mainmenuselect.optionselected == 0):
					showtext = true
					message = "START GAME"
				if (obj_mainmenuselect.optionselected == 1):
					showtext = true
					message = "OPTION"
				if (obj_mainmenuselect.optionselected == 2):
					showtext = true
					message = "ERASE DATA"
			else:
				showtext = true
				message = ""
	if (obj_player.state == global.states.keyget):
		showtext = true
		message = "GOT THE KEY!"
		$ResetTimer.wait_time = 0.83
		$ResetTimer.start()
	$ComboBubble/ComboMeter.value = global.combotime
	if (global.combotime < 20):
		combo_posX = lerp(rand_range(-2, 0), rand_range(2, 5), 0.01)
	else:
		combo_posX = 0
	if (global.combotime > 0 && global.combo != 0):
		match combo_state:
			0:
				combo_posY += combo_vsp
				combo_vsp += 0.5
				if (combo_posY > 0):
					combo_state += 1
			1:
				combo_posY = lerp(combo_posY, 0, 0.05)
				if (combo_posY < 1):
					combo_posY = 0
					combo_vsp = 0
					combo_state += 1
			2:
				if (global.combotime < 30):
					combo_posY += combo_vsp
					if (combo_vsp < 20):
						combo_vsp += 0.5
					if (combo_posY > 0):
						combo_posY = 0
						combo_vsp -= 1
						if (global.combotime < 15):
							combo_vsp = -2
				else:
					combo_posY = lerp(combo_posY, 0, 0.25)
	else:
		combo_posY = lerp(combo_posY, -500, 0.025)
		combo_vsp = 0
		combo_state = 0
	$ComboBubble.position.x = 344 + combo_posX
	$ComboBubble.position.y = -72 + combo_posY

func _on_ResetTimer_timeout():
	showtext = false
	tvsprite = "default"
	$TVSprite.speed_scale = 0.1
	imageindexstore = 0
