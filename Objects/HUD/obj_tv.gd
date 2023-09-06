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

func _process(delta):
	$MessageLabel.text = message
	$TVSprite.animation = tvsprite
	$TVSprite.playing = true
	if (global.combo != 0 && global.combotime != 0 && (tvsprite == "default" || tvsprite == "combo")):
		$ComboLabel.visible = false
		$ComboLabel.text = str(global.combo)
	else:
		$ComboLabel.visible = false
	if (tvsprite == "default"):
		chose = false
		$ScoreLabel.text = str(global.collect)
	if (global.targetRoom == "rank_room" || global.targetRoom == "timesuproom" || global.targetRoom == "Realtitlescreen"):
		$TVSprite.modulate.a = 0
	match global.targetRoom:
		"entrance_1":
			global.srank = 5750
			global.arank = (global.srank - (global.srank / 4))
			global.brank = (global.srank - ((global.srank / 4) * 2))
			global.crank = (global.srank - ((global.srank / 4) * 3))
		"medieval_1":
			global.srank = 11000
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
		"testroom_1":
			global.srank = 10000
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
	if (obj_player.global_position.y < (global_position.y - 160) && obj_player.global_position.x > (global_position.x + 180)):
		modulate.a = 0.5
	elif (!(global.targetRoom == "rank_room" || global.targetRoom == "timesuproom" || global.targetRoom == "Realtitlescreen")):
		modulate.a = 1
	if (utils.instance_exists("obj_itspizzatime")):
		$TVSprite.speed_scale = 0.25
		message = "GET TO THE EXIT!!"
		$ResetTimer.wait_time = 3.33
		$ResetTimer.start()
		showtext = true
		tvsprite = "exit"
	elif (global.collect > global.arank && !shownranka):
		$TVSprite.speed_scale = 0
		message = "YOU GOT ENOUGH FOR RANK A"
		showtext = true
		$ResetTimer.wait_time = 3.33
		$ResetTimer.start()
		tvsprite = "ranka"
		shownranka = true
	elif (global.collect > global.brank && !shownrankb):
		$TVSprite.speed_scale = 0
		message = "YOU GOT ENOUGH FOR RANK b"
		showtext = true
		$ResetTimer.wait_time = 3.33
		$ResetTimer.start()
		tvsprite = "rankb"
		shownrankb = true
	elif (global.collect > global.crank && !shownrankc):
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
	elif (global.combo != 0 && global.combotime != 0 && (tvsprite == "default" || tvsprite == "combo" || tvsprite == "escape")):
		tvsprite = "combo"
		$TVSprite.speed_scale = 0
		if (global.combo >= 4):
			imageindexstore = 3
		else:
			imageindexstore = (global.combo - 1)
	elif (global.combotime == 0 && tvsprite == "combo"):
		tvsprite = "comboresult"
		$TVSprite.speed_scale = 0
		$TVSprite.frame = imageindexstore
		$ResetTimer.wait_time = 0.83
		$ResetTimer.start()
	elif (global.targetRoom == "Realtitlescreen"):
		$TVSprite.speed_scale = 0.1
		tvsprite = "banana"
		$ResetTimer.wait_time = 0.03
		$ResetTimer.start()
		if (utils.instance_exists("obj_mainmenuselect")):
			var obj_mainmenuselect = utils.get_instance_level("obj_mainmenuselect")
			if (obj_mainmenuselect.selected == 0):
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
	

func _on_ResetTimer_timeout():
	showtext = false
	tvsprite = "default"
	$TVSprite.speed_scale = 0.1
	imageindexstore = 0
