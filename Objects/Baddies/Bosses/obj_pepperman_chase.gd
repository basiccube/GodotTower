extends Area2D

var velocity = Vector2.ZERO
var grav = 0.5
var dead = false
var screamintro = false
var spd = 0

var sprite_index

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35

func _process(delta):
	sprite_index = $Sprite.animation
	var obj_player = utils.get_player()
	if ($Sprite.animation == "charge"):
		position.x += (spd - 0.5)
	if ($Sprite.animation == "charge" && obj_player.movespeed > 5):
		spd = floor(obj_player.movespeed)
	else:
		spd = 5
	if (obj_player.state != global.states.comingoutdoor && !screamintro):
		obj_player.xscale = -1
		obj_player.state = global.states.backbreaker
		obj_player.set_animation("bossintro")
		screamintro = true
	if (obj_player.state != global.states.backbreaker && screamintro && $Sprite.animation != "charge" && !dead):
		utils.instance_create_level(position.x, position.y, "res://Objects/Visuals/obj_peppermancharge.tscn")
		$Sprite.animation = "charge"
	if (dead):
		if (velocity.y < 12):
			velocity.y += grav
		position.x += velocity.x
		position.y += velocity.y
	if (overlaps_body(obj_player)):
		if (obj_player.state != global.states.ejected && !dead):
			utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_bangeffect.tscn")
			for i in 6:
				utils.instance_create(obj_player.position.x, obj_player.position.y, "res://Objects/Visuals/obj_slapstar.tscn")
			obj_player.state = global.states.ejected
			obj_player.velocity.y = -10
			global.saveroom.clear()
			global.baddieroom.clear()
	if (obj_player.state != global.states.ejected && !utils.instance_exists("obj_fadeout")):
		for i in get_overlapping_bodies():
			if i.is_in_group("obj_peppermandestroyable"):
				i.destroy()
			if i.is_in_group("obj_slipnslide"):
				if (!i.drop):
					utils.instance_create(position.x, position.y, "res://Objects/Level/obj_key.tscn")
					dead = true
					$Sprite.animation = "hurt"
					velocity.x = spd
					i.drop = true
	if (!$ScreenVisibility.is_on_screen() && dead):
		for i in get_tree().get_nodes_in_group("obj_peppermancharge"):
			i.queue_free()
		queue_free()
