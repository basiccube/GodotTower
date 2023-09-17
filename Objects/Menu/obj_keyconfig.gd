extends Node2D

var key_select = -1
var selecting = -1

func _process(delta):
	if ((Input.is_action_just_pressed("key_grab") || Input.is_action_just_pressed("key_escape")) && selecting == -1 && key_select == -1):
		utils.playsound("EnemyProjectile")
		var obj_option = utils.get_instance("obj_option")
		obj_option.visible = true
		queue_free()
