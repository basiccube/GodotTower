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
		if (obj_player.is_on_floor() && $Sprite.animation == "doorkey" && Input.is_action_pressed("key_up") && (obj_player.state == global.states.normal || obj_player.state == global.states.mach1 || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3 || obj_player.state == global.states.Sjumpprep) && global.key_inv):
			global.saveroom.append(global.targetRoom + name)
			obj_player.state = global.states.victory
			obj_player.set_animation("victory")
			$Sprite.animation = "doorkeyopen"
			$Sprite.speed_scale = 0.35
			utils.instance_create_level(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_lock.tscn")
			global.key_inv = false
	if (overlaps_body(obj_player)):
		if (obj_player.is_on_floor() && $Sprite.animation == "visited" && Input.is_action_pressed("key_up") && (obj_player.state == global.states.normal || obj_player.state == global.states.mach1 || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3) && !utils.instance_exists("obj_fadeout") && obj_player.state != global.states.door && obj_player.state != global.states.victory && obj_player.state != global.states.comingoutdoor):
			obj_player.mach2 = 0
			for i in get_tree().get_nodes_in_group("obj_camera"):
				i.chargecamera = 0
			obj_player.set_animation("lookdoor")
			utils.playsound("Door")
			global.targetDoor = targetDoor
			obj_player.targetLevel = targetLevel
			obj_player.targetRoom = targetRoom
			obj_player.state = global.states.door
			utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_fadeout.tscn")
	if ($Sprite.frame == 2):
		$Sprite.speed_scale = 0
	# This code needs some sort of checking whether or not the player is standing in this specific door
	if (obj_player.pepsprite.frame == obj_player.pepsprite.frames.get_frame_count(obj_player.pepsprite.animation) - 1 && obj_player.state == global.states.victory):
		obj_player.targetLevel = targetLevel
		obj_player.targetRoom = targetRoom
		global.targetDoor = targetDoor
		if (!utils.instance_exists("obj_fadeout")):
			utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_fadeout.tscn")

func _on_obj_door_body_entered(body):
	if body is obj_player:
		utils.get_player().indoor = true

func _on_obj_door_body_exited(body):
	if body is obj_player:
		utils.get_player().indoor = false
