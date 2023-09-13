extends Area2D

onready var sprite = $Sprite

func _ready():
	sprite.playing = true
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
			if (obj_player.state != global.states.knightpep || obj_player.state != global.states.knightpepattack):
				utils.playsound("LoseKnight")
				var knightdebris1 = utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
				knightdebris1.frame = 0
				var knightdebris2 = utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
				knightdebris2.frame = 1
				var knightdebris3 = utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
				knightdebris3.frame = 2
				var knightdebris4 = utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
				knightdebris4.frame = 3
				var knightdebris5 = utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
				knightdebris5.frame = 4
				var knightdebris6 = utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_knightdebris.tscn")
				knightdebris6.frame = 5
				if (obj_player.position.x != position.x):
					obj_player.velocity.x = (sign((obj_player.position.x - position.x) * 5))
			obj_player.hurted = 1
			obj_player.velocity.y = -4
			obj_player.set_animation("bombpep_end")
			obj_player.state = global.states.bombpep
			obj_player.bombpeptimer = 0

func _on_Sprite_animation_finished():
	queue_free()
