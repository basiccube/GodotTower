extends Node2D

func _process(delta):
	if (Input.is_action_just_pressed("key_debug1")):
		global.debugview = !global.debugview
	if (Input.is_action_just_pressed("key_debug2")):
		global.debugcollisions = !global.debugcollisions
	for i in get_tree().get_nodes_in_group("obj_solid"):
		i.visible = global.debugcollisions
	for i in get_tree().get_nodes_in_group("obj_slope"):
		i.visible = global.debugcollisions
	for i in get_tree().get_nodes_in_group("obj_platform"):
		i.visible = global.debugcollisions
	for i in get_tree().get_nodes_in_group("obj_secretblock"):
		i.visible = global.debugcollisions
	for i in get_tree().get_nodes_in_group("obj_secretbigblock"):
		i.visible = global.debugcollisions
	for i in get_tree().get_nodes_in_group("obj_secretmetalblock"):
		i.visible = global.debugcollisions
