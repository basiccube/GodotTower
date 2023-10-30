extends Area2D

onready var sprite = "shotgunbullet"
var spd = (scale.x * 25)
var spdh = 0

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.5
	var obj_player = utils.get_player()
	scale.x = obj_player.xscale
	
func destroy():
	queue_free()

func _process(delta):
	$Sprite.animation = sprite
	if ($SolidCheck.is_colliding() && $SolidCheck.get_collider() != null && ($SolidCheck.get_collider().is_in_group("obj_solid") || $SolidCheck.get_collider().is_in_group("obj_slope")) && !$SolidCheck.get_collider().is_in_group("obj_destructibles")):
		destroy()
	position.x += spd * scale.x
	position.y += (-spdh)

func _on_obj_shotgunbullet_body_entered(body):
	if body.is_in_group("obj_destructibles") && !body.is_in_group("obj_specialdestructibles"):
		body.destroy()
	if body is obj_baddie:
		if (body.hp <= 1):
			destroy()
			body.destroy()
		else:
			body.hp -= 1
			utils.playsound("HitEnemy")
			utils.playsound("Punch")
			global.hit += 1
			global.combotime = 60
			utils.instance_create(body.global_position.x, body.global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
			utils.instance_create(body.global_position.x, body.global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
			body.state = global.states.stun
			if (body.stunned < 100):
				body.stunned = 100
			utils.instance_create(body.global_position.x, body.global_position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
			utils.instance_create(body.global_position.x, body.global_position.y, "res://Objects/Visuals/obj_bangeffect.tscn")
			body.velocity.y = -4
			body.velocity.x = scale.x * 5
