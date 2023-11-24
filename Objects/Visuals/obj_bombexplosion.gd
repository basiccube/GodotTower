extends Area2D

onready var sprite = $Sprite

func _ready():
	sprite.playing = true
	monitoring = true
	sprite.speed_scale = 0.5
	if (utils.soundplaying("Explosion")):
		utils.stopsound("Explosion")
	utils.playsound("Explosion")
	
func _process(delta):
	if (sprite.frame > 9):
		monitoring = false
	if (overlaps_body(utils.get_player())):
		var obj_player = utils.get_player()
		if (obj_player.hurted == 0 && !obj_player.cutscene && obj_player.state != global.states.bombpep && obj_player.sprite_index != "bombpep_end" && obj_player.state != global.states.Sjump && obj_player.state != global.states.Sjumpprep):
			if (obj_player.state == global.states.knightpep || obj_player.state == global.states.knightpepattack || obj_player.state == global.states.knightpepslopes):
				utils.playsound("LoseKnight")
				var debris1 = utils.instance_create(obj_player.global_position.x, obj_player.global_position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
				debris1.sprite.frame = 0
				var debris2 = utils.instance_create(obj_player.global_position.x, obj_player.global_position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
				debris2.sprite.frame = 1
				var debris3 = utils.instance_create(obj_player.global_position.x, obj_player.global_position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
				debris3.sprite.frame = 2
				var debris4 = utils.instance_create(obj_player.global_position.x, obj_player.global_position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
				debris4.sprite.frame = 3
				var debris5 = utils.instance_create(obj_player.global_position.x, obj_player.global_position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
				debris5.sprite.frame = 4
				var debris6 = utils.instance_create(obj_player.global_position.x, obj_player.global_position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
				debris6.sprite.frame = 5
				if (obj_player.position.x != position.x):
					obj_player.velocity.x = (sign((obj_player.position.x - position.x) * 5))
			obj_player.velocity.y = -4
			obj_player.set_animation("bombpep_end")
			obj_player.bombpeptimer = 0
			obj_player.hurted = 1
			obj_player.state = global.states.bombpep

func _on_Sprite_animation_finished():
	queue_free()
