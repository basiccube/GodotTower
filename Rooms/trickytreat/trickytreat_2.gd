extends Node2D

func _ready():
	if (global.targetDoor == "C"):
		utils.get_player().backtohubstartx = 210
		utils.get_player().backtohubstarty = 1234
		utils.get_player().backtohubroom = "hub_room1"
		global.leveltorestart = "trickytreat"
		global.roomtorestart = "trickytreat_1"
		global.collect = 2800
		global.secretfound = 6
		global.laps = 1
		global.timeattack = true
		global.taminutes = 0
		global.taseconds = 25
