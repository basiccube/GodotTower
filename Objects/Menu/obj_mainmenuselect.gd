extends Node2D

var optionselected = 0
var selected = false

func _process(delta):
	if (!selected):
		if (Input.is_action_just_pressed("key_right") && optionselected < 2):
			optionselected += 1
			utils.playsound("Step")
		if (Input.is_action_just_pressed("key_left") && optionselected > 0):
			optionselected -= 1
			utils.playsound("Step")
		if (Input.is_action_just_pressed("key_jump") && optionselected == 0):
			utils.playsound("CollectToppin")
			var obj_file1 = utils.get_instance_level("obj_file1")
			obj_file1.sprite.animation = "file1confirm"
			selected = true
			$StartTimer.start()
		if (Input.is_action_just_pressed("key_jump") && optionselected == 1):
			utils.playsound("CollectToppin")
			selected = true
			$OptionTimer.start()
		if (Input.is_action_just_pressed("key_jump") && optionselected == 2):
			utils.playsound("CollectToppin")
			selected = true
			$EraseTimer.start()
	utils.get_level().menulight.animation = "selection" + str(optionselected + 1)

func _on_StartTimer_timeout():
	utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_fadeout.tscn")
	utils.get_player().targetRoom = "characterselect"

func _on_OptionTimer_timeout():
	utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Menu/obj_option.tscn")

func _on_EraseTimer_timeout():
	utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Menu/obj_erasegame.tscn")
