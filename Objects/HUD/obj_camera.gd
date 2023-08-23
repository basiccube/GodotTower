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
	if (global.room == "rank_room" || global.room == "timesuproom" || global.room == "Realtitlescreen"):
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
	
