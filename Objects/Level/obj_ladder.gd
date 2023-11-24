tool
extends Area2D

func _ready():
	z_index = -2
	
func _process(delta):
	if !Engine.editor_hint:
		var obj_player = utils.get_player()
		if ($PlayerCheck.is_colliding() && $PlayerCheck.get_collider().is_in_group("obj_player")):
			if (Input.is_action_pressed("key_down") && obj_player.state == global.states.crouch && obj_player.slopecheck.is_colliding() && obj_player.slopecheck.get_collider().is_in_group("obj_platform")):
				obj_player.position.y += 25
				obj_player.velocity.x = 0
				obj_player.state = global.states.ladder
				obj_player.position.x = position.x + 16
				obj_player.position.y = floor(obj_player.position.y)
				if ((fmod(obj_player.position.y, float(2))) == float(1)):
					obj_player.position.y -= 1
		if (overlaps_body(obj_player)):
			if (Input.is_action_pressed("key_up") && obj_player.ladderbuffer == 0 && (obj_player.state == global.states.normal || obj_player.state == global.states.mach2 || obj_player.state == global.states.mach3 || obj_player.state == global.states.mach1 || obj_player.state == global.states.shotgunjump || obj_player.state == global.states.jump) && (obj_player.state != global.states.hurt && obj_player.state != global.states.machslide && obj_player.state != global.states.freefall && obj_player.state != global.states.freefallland)):
				obj_player.mach2 = 0
				obj_player.velocity.x = 0
				obj_player.state = global.states.ladder
				obj_player.position.x = position.x + 16
				obj_player.position.y = floor(obj_player.position.y)
				if ((fmod(obj_player.position.y, float(2))) == float(1)):
					obj_player.position.y -= 1
	$Sprite.region_rect.size.y = 32 * scale.y
	$Sprite.scale.y = 1 / scale.y
	$PlayerCheck.scale.y = 1 / scale.y



