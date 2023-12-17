extends Area2D

export(String) var targetLevel = ""
export(String) var targetRoom = ""

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()

func _process(delta):
	$Sprite.material.set_shader_param("current_palette", global.peppalette)
	if (global.panic):
		modulate.a = 1
	else:
		modulate.a = 0.5
	var obj_player = utils.get_player()
	if (overlaps_body(obj_player)):
		if (obj_player.state != global.states.portal && global.panic):
			obj_player.velocity.x = 0
			$Sprite.animation = "pizzaportalend"
			obj_player.state = global.states.portal
			obj_player.visible = false

func _on_Sprite_animation_finished():
	if ($Sprite.animation == "pizzaportalend"):
		var obj_player = utils.get_player()
		global.saveroom.append(global.targetRoom + name)
		obj_player.targetLevel = targetLevel
		obj_player.targetRoom = targetRoom
		global.collect += 500
		global.style += 10
		var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
		smallnumbid.number = "500"
		global.combotime = 60
		global.laps += 1
		global.escaperoom.clear()
		utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_fadeout.tscn")
