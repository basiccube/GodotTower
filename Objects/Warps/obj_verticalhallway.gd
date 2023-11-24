extends Node2D

# NOTE: This doesn't function in any way similiar to how it does in the actual game.

export(String) var targetDoor = "A"
export(String) var targetLevel = "testroom"
export(String) var targetRoom = "testroom_1"

func _ready():
	if global.targetDoor != "" && global.targetDoor == targetDoor:
		var obj_player = utils.get_player()
		obj_player.position.x = (position.x + 32 * scale.x)
		obj_player.position.y = (position.y + (50 * (-scale.y)))
		obj_player.roomstartx = obj_player.position.x
		obj_player.roomstarty = obj_player.position.y


func _on_obj_hallway_body_entered(body):
	if body is obj_player:
		if (!utils.instance_exists("obj_fadeout")):
			var obj_player = utils.get_player()
			obj_player.targetRoom = targetRoom
			obj_player.targetLevel = targetLevel
			global.targetDoor = targetDoor
			utils.playsound("Door")
			utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_fadeout.tscn")
