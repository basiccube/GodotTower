extends Area2D

var visited = false

export(String) var targetDoor = "A"
export(String) var targetLevel = "testroom"
export(String) var targetRoom = "testroom_1"

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	if global.targetDoor != "" && global.targetDoor == targetDoor:
		var obj_player = utils.get_player()
		obj_player.global_position.x = global_position.x
		obj_player.global_position.y = global_position.y
		obj_player.xscale = 1
		visited = true
	if (global.saveroom.has(global.targetRoom + name)):
		$Sprite.animation = "visited"
		
func _process(delta):
	if (visited):
		$Sprite.animation = "visited"
	var obj_player = utils.get_player()
	if (overlaps_body(obj_player)):
		if (obj_player.is_on_floor() && Input.is_action_pressed("key_up") && (obj_player.state == global.states.normal || obj_player.state == global.states.mach1 || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3 || obj_player.state == global.states.Sjumpprep) && !utils.instance_exists("obj_fadeout") && obj_player.state != global.states.door && obj_player.state != global.states.comingoutdoor):
			obj_player.lastroom_x = position.x
			obj_player.lastroom_y = position.y
			obj_player.lastroom = global.targetRoom
			utils.playsound("Door")
			for i in get_tree().get_nodes_in_group("obj_camera"):
				i.chargecamera = 0
			global.saveroom.append(global.targetRoom + name)
			obj_player.set_animation("lookdoor")
			global.targetDoor = targetDoor
			obj_player.targetLevel = targetLevel
			obj_player.targetRoom = targetRoom
			obj_player.state = global.states.door
			obj_player.mach2 = 0
			visited = true
			utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_fadeout.tscn")

func _on_obj_door_body_entered(body):
	if body is obj_player:
		utils.get_player().indoor = true

func _on_obj_door_body_exited(body):
	if body is obj_player:
		utils.get_player().indoor = false
