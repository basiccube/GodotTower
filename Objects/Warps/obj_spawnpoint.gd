extends Node2D

export(String) var targetDoor = "A"

func _ready():
	visible = false
	if global.targetDoor == targetDoor:
		var obj_player = utils.get_player()
		obj_player.global_position.x = global_position.x
		obj_player.global_position.y = global_position.y
		obj_player.xscale = sign(scale.x)
