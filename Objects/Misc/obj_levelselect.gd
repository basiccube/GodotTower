extends Node2D

var selected_level = 0

var level_array = [
	["ENTRANCE", "entrance", "entrance_1"],
	["PIZZASCAPE", "medieval", "medieval_1"],
	["THE ANCIENT CHEESE", "ruin", "ruin_1"],
	["BLOODSAUCE DUNGEON", "dungeon", "dungeon_1"],
	["TRICKY TREAT", "trickytreat", "trickytreat_1"],
]

func _process(delta):
	$SelectionText.text = level_array[selected_level][0]
	selected_level += ((-int(Input.is_action_just_pressed("key_left"))) + int(Input.is_action_just_pressed("key_right")))
	selected_level = clamp(selected_level, 0, level_array.size() - 1)
	if (Input.is_action_just_pressed("key_jump") && !utils.instance_exists("obj_fadeout")):
		var obj_player = utils.get_player()
		obj_player.state = global.states.comingoutdoor
		obj_player.targetLevel = level_array[selected_level][1]
		obj_player.targetRoom = level_array[selected_level][2]
		global.leveltorestart = level_array[selected_level][1]
		global.roomtorestart = level_array[selected_level][2]
		global.targetDoor = "A"
		utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_fadeout.tscn")
