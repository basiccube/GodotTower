extends Node2D

var selection = 0
var ready = false

func _ready():
	$Player1.speed_scale = 0.35
	$Player1.playing = true
	
func _process(delta):
	if (Input.is_action_just_pressed("key_right") && selection == 0 && !ready):
		selection += 1
		utils.playsound("Step")
	if (Input.is_action_just_pressed("key_left") && selection == 1 && !ready):
		selection -= 1
		utils.playsound("Step")
	if (Input.is_action_just_pressed("key_jump") && !ready):
		ready = true
		utils.playsound("CollectToppin")
		if (selection == 0):
			utils.get_instance_level("obj_peppinoselect").sprite.animation = "peppinoselected"
			utils.get_player().character = "P"
		elif (selection == 1):
			utils.get_instance_level("obj_noiseselect").sprite.animation = "noiseselected"
			utils.get_player().character = "N"
		$StartTimer.start()
	if (!ready):
		$Player1.animation = "player1cursor"
	else:
		$Player1.animation = "player1cursorselected"
	if (selection == 0):
		$Player1.position.x = 344
	elif (selection == 1):
		$Player1.position.x = 528

func _on_StartTimer_timeout():
	utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_fadeout.tscn")
	utils.get_player().targetRoom = "Scootertransition"
