extends Node2D

var optionselected = 0
var optionsaved_stylebar = global.stylebar
var optionsaved_may2019run = global.may2019run
var optionsaved_shoulderbash = global.shoulderbash
var optionsaved_oldgrab = global.oldgrab

func _process(delta):
	if (Input.is_action_just_pressed("key_up") && optionselected > -1):
		optionselected -= 1
		utils.playsound("Step")
	if (Input.is_action_just_pressed("key_down") && optionselected < 3):
		optionselected += 1
		utils.playsound("Step")
	if (optionselected == -1):
		if (Input.is_action_just_pressed("key_jump")):
			utils.playsound("EnemyProjectile")
			var obj_option = utils.get_instance("obj_option")
			obj_option.visible = true
			queue_free()
	if (optionselected == 0):
		if (Input.is_action_just_pressed("key_right") && !optionsaved_stylebar):
			optionsaved_stylebar = true
		if (Input.is_action_just_pressed("key_left") && optionsaved_stylebar):
			optionsaved_stylebar = false
		if (Input.is_action_just_pressed("key_jump")):
			global.stylebar = optionsaved_stylebar
	if (optionselected == 1):
		if (Input.is_action_just_pressed("key_right") && !optionsaved_may2019run):
			optionsaved_may2019run = true
		if (Input.is_action_just_pressed("key_left") && optionsaved_may2019run):
			optionsaved_may2019run = false
		if (Input.is_action_just_pressed("key_jump")):
			global.may2019run = optionsaved_may2019run
	if (optionselected == 2):
		if (Input.is_action_just_pressed("key_right") && !optionsaved_shoulderbash):
			optionsaved_shoulderbash = true
		if (Input.is_action_just_pressed("key_left") && optionsaved_shoulderbash):
			optionsaved_shoulderbash = false
		if (Input.is_action_just_pressed("key_jump")):
			global.shoulderbash = optionsaved_shoulderbash
	if (optionselected == 3):
		if (Input.is_action_just_pressed("key_right") && !optionsaved_oldgrab):
			optionsaved_oldgrab = true
		if (Input.is_action_just_pressed("key_left") && optionsaved_oldgrab):
			optionsaved_oldgrab = false
		if (Input.is_action_just_pressed("key_jump")):
			global.oldgrab = optionsaved_oldgrab
	# Menu draw code
	if (optionselected == -1):
		$Back.modulate.a = 1
		$Description.text = ""
	else:
		$Back.modulate.a = 0.5
	if (optionselected == 0):
		$StyleBar.modulate.a = 1
		$Description.text = "Enables the April 2019 style bar and score multiplier system."
	else:
		$StyleBar.modulate.a = 0.5
	if (optionsaved_stylebar):
		$StyleBar.text = "STYLE BAR: ON"
	else:
		$StyleBar.text = "STYLE BAR: OFF"
	if (optionselected == 1):
		$OldMach1.modulate.a = 1
		$Description.text = "Replaces the mach 1 animation with the one from May 2019."
	else:
		$OldMach1.modulate.a = 0.5
	if (optionsaved_may2019run):
		$OldMach1.text = "MAY 2019 MACH 1 RUN: ON"
	else:
		$OldMach1.text = "MAY 2019 MACH 1 RUN: OFF"
	if (optionselected == 2):
		$ShoulderBash.modulate.a = 1
		$Description.text = "Replaces the grab with the shoulder bash.\nThe grab can still be performed by pressing Up and Grab."
	else:
		$ShoulderBash.modulate.a = 0.5
	if (optionsaved_shoulderbash):
		$ShoulderBash.text = "SHOULDER BASH: ON"
	else:
		$ShoulderBash.text = "SHOULDER BASH: OFF"
	if (optionselected == 3):
		$OldGrab.modulate.a = 1
		$Description.text = "Enables the grab from early 2019."
	else:
		$OldGrab.modulate.a = 0.5
	if (optionsaved_oldgrab):
		$OldGrab.text = "OLD GRAB: ON"
	else:
		$OldGrab.text = "OLD GRAB: OFF"
