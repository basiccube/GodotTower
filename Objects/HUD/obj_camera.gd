extends Camera2D

var shake_mag = 0
var shake_mag_acc = 0
var chargecamera = 0
var ded = 0

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
	if (global.seconds <= 0 && global.minutes <= 0 && ded == 0):
		#for i in get_tree().get_nodes_in_group("obj_music"):
			# music, please stop now.
		ded = 1
	if (global.seconds < 0):
		global.seconds = 59
		global.minutes -= 1
	if (global.seconds > 59):
		global.minutes += 1
		global.seconds -= 59
	if ((global.panic && global.minutes < 1) || utils.get_player().sprite_index == "timesup"):
		shake_mag = 2
		shake_mag_acc = (3 / delta)
	elif (global.panic):
		shake_mag = 2
		shake_mag_acc = (3 / delta)
	if (shake_mag > 0):
		shake_mag -= shake_mag_acc
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
	var obj_player = utils.get_player()
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
	
