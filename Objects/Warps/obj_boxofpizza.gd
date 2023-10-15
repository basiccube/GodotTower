extends StaticBody2D

export(String) var targetDoor = "A"
export(String) var targetLevel = "testroom"
export(String) var targetRoom = "testroom_1"

func _ready():
	if global.targetDoor != "" && global.targetDoor == targetDoor:
		var obj_player = utils.get_player()
		obj_player.position.x = (position.x - 50)
		if (scale.y == 1):
			obj_player.position.y = (position.y - 96)
		if (scale.y == -1):
			obj_player.position.y = (position.y - 50)
		obj_player.roomstartx = obj_player.position.x
		obj_player.roomstarty = obj_player.position.y
		obj_player.xscale = (-sign(scale.x))
		obj_player.box = false

func _process(delta):
	var obj_player = utils.get_player()
	if (scale.y == 1):
		if ((Input.is_action_pressed("key_down") && (obj_player.state == global.states.crouch || obj_player.state == global.states.machroll || obj_player.state == global.states.crouchslide || obj_player.state == global.states.freefall) || obj_player.state == global.states.freefallland) && $PlayerArea.overlaps_body(obj_player) && (!utils.instance_exists("obj_fadeout")) && obj_player.state != global.states.door && obj_player.state != global.states.comingoutdoor):
			utils.playsound("Box")
			obj_player.mach2 = 0
			utils.get_instance("obj_camera").chargecamera = 0
			obj_player.position.x = (position.x - 50)
			obj_player.position.y = (position.y - 96)
			global.targetDoor = targetDoor
			obj_player.targetLevel = targetLevel
			obj_player.targetRoom = targetRoom
			obj_player.set_animation("downpizzabox")
			obj_player.state = global.states.door
	if (scale.y == -1):
		if ((Input.is_action_pressed("key_up") && (obj_player.state == global.states.normal || obj_player.state == global.states.jump || obj_player.state == global.states.mach1 || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3 || obj_player.state == global.states.Sjumpprep || obj_player.state == global.states.Sjump) || obj_player.state == global.states.Sjumpland) && $PlayerArea.overlaps_body(obj_player) && (!utils.instance_exists("obj_fadeout")) && obj_player.state != global.states.door && obj_player.state != global.states.comingoutdoor):
			utils.playsound("Box")
			obj_player.mach2 = 0
			utils.get_instance("obj_camera").chargecamera = 0
			obj_player.position.x = (position.x - 50)
			obj_player.position.y = (position.y - 50)
			global.targetDoor = targetDoor
			obj_player.targetLevel = targetLevel
			obj_player.targetRoom = targetRoom
			obj_player.set_animation("uppizzabox")
			obj_player.state = global.states.door
