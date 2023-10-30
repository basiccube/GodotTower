extends Node2D

func _process(delta):
	if (Input.is_action_just_pressed("key_debug1")):
		global.debugview = !global.debugview
	if (Input.is_action_just_pressed("key_debug2")):
		global.debugcollisions = !global.debugcollisions
	if (Input.is_action_just_pressed("key_debug3")):
		var obj_player = utils.get_player()
		obj_player.position.x = obj_player.roomstartx
		obj_player.position.y = obj_player.roomstarty
	for i in get_tree().get_nodes_in_group("collision"):
		i.visible = global.debugcollisions
	for i in get_tree().get_nodes_in_group("obj_secretblock"):
		i.visible = global.debugcollisions
	for i in get_tree().get_nodes_in_group("obj_secretbigblock"):
		i.visible = global.debugcollisions
	for i in get_tree().get_nodes_in_group("obj_secretmetalblock"):
		i.visible = global.debugcollisions
