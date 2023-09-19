extends Camera2D

var shake_mag = 0
var shake_mag_acc = 0
var chargecamera = 0
var ded = 0
onready var panictimer = $panictimer
onready var dedtimer = $dedtimer

func room_start():
	position = utils.get_player().position
	shake_mag = 0
	shake_mag_acc = 0

func _ready():
	room_start()
	
func _process(delta):
	if (global.targetRoom == "rank_room" || global.targetRoom == "timesuproom" || global.targetRoom == "Realtitlescreen"):
		visible = false
	else:
		visible = true
	if (global.debugview):
		limit_left = -10000000
		limit_top = -10000000
		limit_right = 10000000
		limit_bottom = 10000000
	if (global.seconds <= 0 && global.minutes <= 0 && ded == 0):
		$panictimer.stop()
		$dedtimer.wait_time = 0.05
		$dedtimer.start()
		for i in get_tree().get_nodes_in_group("obj_music"):
			i.musicnode.stop()
		ded = 1
	if (global.seconds < 0):
		global.seconds = 59
		global.minutes -= 1
	if (global.seconds > 59):
		global.minutes += 1
		global.seconds -= 59
	if ((global.panic && global.minutes < 1) || utils.get_player().sprite_index == "timesup"):
		shake_mag = 2
		shake_mag_acc = (3 / 10)
	elif (global.panic):
		shake_mag = 2
		shake_mag_acc = (3 / 10)
	if (shake_mag > 0):
		shake_mag -= shake_mag_acc
		if (shake_mag_acc == 0):
			shake_mag -= 0.1
		if (shake_mag < 0):
			shake_mag = 0
	if (utils.instance_exists("obj_player") && utils.get_player().state != global.states.timesup && utils.get_player().state != global.states.gameover):
		var target = utils.get_player()
		if (target.state == global.states.mach3 || target.state == global.states.machroll):
			if (chargecamera > (target.xscale * 100)):
				chargecamera -= 2
			if (chargecamera < (target.xscale * 100)):
				chargecamera += 2
			position.x = (target.position.x + chargecamera)
		else:
			if (chargecamera > 0):
				chargecamera -= 2
			if (chargecamera < 0):
				chargecamera += 2
			position.x = (target.position.x + chargecamera)
		position.y = target.position.y
		if (shake_mag != 0):
			position.y = (target.position.y + utils.randi_range((-shake_mag), shake_mag))
	global_position.x = clamp(global_position.x, (limit_left + 480), (limit_right - 480))
	global_position.y = clamp(global_position.y, (limit_top + 270), (limit_bottom - 270))
	if (shake_mag != 0):
		global_position.y = clamp(global_position.y, (limit_top + 270 + utils.randi_range((-shake_mag), shake_mag)), (limit_bottom - 270 + utils.randi_range((-shake_mag), shake_mag)))
	var obj_player = utils.get_player()
	if (obj_player.state != global.states.gameover):
		# Character face HUD code
		$FaceHUD.playing = true
		if (obj_player.sprite_index == "knightpep_thunder"):
			$FaceHUD.animation = "thunder"
		elif (obj_player.sprite_index != "knightpep_start" && (obj_player.state == global.states.knightpep || obj_player.state == global.states.knightpepslopes)):
			$FaceHUD.animation = "knight"
		elif (obj_player.sprite_index == "bombpep_end"):
			$FaceHUD.animation = "bombend"
		elif (utils.instance_exists("obj_itspizzatime") || obj_player.sprite_index == "bombpep_intro" || obj_player.sprite_index == "bombpep_runabouttoexplode" || obj_player.sprite_index == "bombpep_run" || obj_player.sprite_index == "fireass"):
			$FaceHUD.animation = "scream"
		elif (obj_player.state == global.states.Sjumpland || (obj_player.state == global.states.freefallland && shake_mag > 0)):
			$FaceHUD.animation = "stun"
		elif (obj_player.sprite_index == "victory" || obj_player.state == global.states.keyget || obj_player.state == global.states.smirk || obj_player.state == global.states.gottreasure || (obj_player.state == global.states.bossintro && obj_player.sprite_index == "levelcomplete")):
			$FaceHUD.animation = "happy"
		elif (obj_player.sprite_index == "machroll" || obj_player.sprite_index == "tumble"):
			$FaceHUD.animation = "rolling"
		elif (global.combo >= 3):
			$FaceHUD.animation = "menacing"
		elif (obj_player.state == global.states.mach1 || obj_player.state == global.states.freefallprep || obj_player.state == global.states.freefall || obj_player.state == global.states.tackle || obj_player.state == global.states.Sjump || obj_player.state == global.states.slam || obj_player.state == global.states.Sjumpprep || obj_player.state == global.states.grab || obj_player.state == global.states.punch || obj_player.state == global.states.backbreaker || obj_player.state == global.states.backkick || obj_player.state == global.states.shoulder || obj_player.state == global.states.uppunch):
			$FaceHUD.animation = "mach1"
		elif (obj_player.state == global.states.mach2 || obj_player.sprite_index == "dive" || obj_player.sprite_index == "machslideboost" || obj_player.state == global.states.climbwall || obj_player.state == global.states.handstandjump):
			$FaceHUD.animation = "mach2"
		elif (obj_player.state == global.states.mach3 && obj_player.sprite_index == "crazyrun"):
			$FaceHUD.animation = "mach4"
		elif (obj_player.state == global.states.mach3 || obj_player.sprite_index == "machslideboost3"):
			$FaceHUD.animation = "mach3"
		elif (obj_player.state == global.states.hurt || obj_player.sprite_index == "fireassend" || obj_player.state == global.states.timesup || obj_player.state == global.states.bombpep || (obj_player.state == global.states.bossintro && obj_player.sprite_index == "bossintro") || (obj_player.state == global.states.bossintro && obj_player.sprite_index == "idle")):
			$FaceHUD.animation = "hurt"
		elif (obj_player.angry):
			$FaceHUD.animation = "3hp"
		elif (obj_player.sprite_index == "hurtidle" || obj_player.sprite_index == "hurtwalk"):
			$FaceHUD.animation = "1hp"
		elif (global.panic):
			$FaceHUD.animation = "panic"
		elif (obj_player.sprite_index == "shotgun_pullout"):
			$FaceHUD.animation = "menacing"
		else:
			$FaceHUD.animation = "idle"
		# Speedbar code
		if (obj_player.movespeed < 2.4 || (!(obj_player.state == global.states.mach1 || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3 || obj_player.state == global.states.climbwall || obj_player.state == global.states.machslide || obj_player.state == global.states.machroll || obj_player.state == global.states.handstandjump))):
			$Speedbar.frame = 0
		elif (obj_player.movespeed >= 2.4 && obj_player.movespeed < 4.8 && (obj_player.state == global.states.mach1 || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3 || obj_player.state == global.states.climbwall || obj_player.state == global.states.machslide || obj_player.state == global.states.machroll || obj_player.state == global.states.handstandjump)):
			$Speedbar.frame = 1
		elif (obj_player.movespeed >= 4.8 && obj_player.movespeed < 7.2 && (obj_player.state == global.states.mach1 || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3 || obj_player.state == global.states.climbwall || obj_player.state == global.states.machslide || obj_player.state == global.states.machroll || obj_player.state == global.states.handstandjump)):
			$Speedbar.frame = 2
		elif (obj_player.movespeed >= 7.2 && obj_player.movespeed < 9.6 && (obj_player.state == global.states.mach1 || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3 || obj_player.state == global.states.climbwall || obj_player.state == global.states.machslide || obj_player.state == global.states.machroll || obj_player.state == global.states.handstandjump)):
			$Speedbar.frame = 3
		elif (obj_player.movespeed >= 9.6 && obj_player.movespeed < 12 && (obj_player.state == global.states.mach1 || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3 || obj_player.state == global.states.climbwall || obj_player.state == global.states.machslide || obj_player.state == global.states.machroll || obj_player.state == global.states.handstandjump)):
			$Speedbar.frame = 4
		elif (obj_player.movespeed >= 12 && $Speedbar.animation != "max" && (obj_player.state == global.states.mach1 || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3 || obj_player.state == global.states.climbwall || obj_player.state == global.states.machslide || obj_player.state == global.states.machroll || obj_player.state == global.states.handstandjump)):
			$Speedbar.animation = "max"
			$Speedbar.playing = true
			$Speedbar.speed_scale = 0.5
		if (obj_player.movespeed < 12 && $Speedbar.animation != "normal"):
			$Speedbar.animation = "normal"
			$Speedbar.playing = false
			$Speedbar.speed_scale = 0
		if (obj_player.global_position.y < (global_position.y - 160) && obj_player.global_position.x < (global_position.x - 240)):
			modulate.a = 0.5
		else:
			modulate.a = 1
		if (global.panic):
			$TimeText.visible = true
			if (global.seconds < 10):
				if (global.minutes < 1):
					$TimeText.add_color_override("font_color", Color(1,0,0))
				else:
					$TimeText.add_color_override("font_color", Color(1,1,1))
				$TimeText.text = str(global.minutes) + ":0" + str(global.seconds)
			elif (global.seconds >= 10):
				if (global.minutes < 1):
					$TimeText.add_color_override("font_color", Color(1,0,0))
				else:
					$TimeText.add_color_override("font_color", Color(1,1,1))
				$TimeText.text = str(global.minutes) + ":" + str(global.seconds)
		else:
			$TimeText.visible = false
		if (global.key_inv):
			$Key.visible = true
			$Key.playing = true
		else:
			$Key.visible = false
			$Key.playing = false

func _on_dedtimer_timeout():
	var obj_player = utils.get_player()
	if (global.seconds == 0 && global.minutes == 0):
		$dedtimer.start()
	if (global.collect > 0):
		utils.instance_create(obj_player.position.x + 50, obj_player.position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
	if (global.collect > 0):
		global.collect -= 5

func _on_panictimer_timeout():
	if (global.panic):
		global.seconds -= 1
		if (global.collect >= 5):
			global.collect -= 5
		if (global.seconds < 0):
			global.seconds = 59
			global.minutes -= 1
	$panictimer.start()
