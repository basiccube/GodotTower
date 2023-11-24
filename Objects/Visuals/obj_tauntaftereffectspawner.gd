extends Node2D

func _ready():
	var effect1 = utils.instance_create(utils.get_player().position.x, utils.get_player().position.y, "res://Objects/Visuals/obj_tauntafterimage.tscn")
	effect1.hspeed = 20
	var effect2 = utils.instance_create(utils.get_player().position.x, utils.get_player().position.y, "res://Objects/Visuals/obj_tauntafterimage.tscn")
	effect2.hspeed = -20
	var effect3 = utils.instance_create(utils.get_player().position.x, utils.get_player().position.y, "res://Objects/Visuals/obj_tauntafterimage.tscn")
	effect3.vspeed = 20
	var effect4 = utils.instance_create(utils.get_player().position.x, utils.get_player().position.y, "res://Objects/Visuals/obj_tauntafterimage.tscn")
	effect4.vspeed = -20
	var effect5 = utils.instance_create(utils.get_player().position.x, utils.get_player().position.y, "res://Objects/Visuals/obj_tauntafterimage.tscn")
	effect5.hspeed = 20
	effect5.vspeed = 20
	var effect6 = utils.instance_create(utils.get_player().position.x, utils.get_player().position.y, "res://Objects/Visuals/obj_tauntafterimage.tscn")
	effect6.hspeed = 20
	effect6.vspeed = -20
	var effect7 = utils.instance_create(utils.get_player().position.x, utils.get_player().position.y, "res://Objects/Visuals/obj_tauntafterimage.tscn")
	effect7.hspeed = -20
	effect7.vspeed = 20
	var effect8 = utils.instance_create(utils.get_player().position.x, utils.get_player().position.y, "res://Objects/Visuals/obj_tauntafterimage.tscn")
	effect8.hspeed = -20
	effect8.vspeed = -20

func _on_Timer_timeout():
	queue_free()
