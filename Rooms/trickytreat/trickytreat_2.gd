extends Node2D

func _ready():
	if (global.targetDoor == "C"):
		utils.get_player().backtohubstartx = 160
		utils.get_player().backtohubstarty = 1184
		global.leveltorestart = "trickytreat"
		global.roomtorestart = "trickytreat_1"
		global.collect = 2800
		global.timeattack = true
		global.taminutes = 0
		global.taseconds = 25
