extends Area2D
		
func _process(delta):
	var obj_player = utils.get_player()
	if (overlaps_body(obj_player)):
		if (obj_player.is_on_floor() && Input.is_action_just_pressed("key_up") && (obj_player.state == global.states.normal || obj_player.state == global.states.mach1 || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3)):
			utils.playsound("Dresser")
			#var clothesid = utils.instance_create((obj_player.position.x), (obj_player.position.y), "res://Objects/Visuals/obj_dresserclothes.tscn")
			#clothesid.velocity.x = utils.randi_range(-5, 5)
			#clothesid.velocity.y = utils.randi_range(-6, -11)
			#clothesid.palette = global.peppalette
			if (global.peppalette < 8):
				global.peppalette += 1
			else:
				global.peppalette = 0

func _on_obj_dresser_body_entered(body):
	if body is obj_player:
		utils.get_player().indoor = true

func _on_obj_dresser_body_exited(body):
	if body is obj_player:
		utils.get_player().indoor = false
