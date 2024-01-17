extends Node2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	
func _process(delta):
	var pepperman = utils.get_instance_level("obj_pepperman")
	position.x = pepperman.position.x + (pepperman.scale.x * 35)
	position.y = pepperman.position.y + 20
	scale.x = pepperman.scale.x
	if (pepperman.is_in_group("obj_pepperman_chase")):
		if (pepperman.sprite_index != "charge"):
			queue_free()
	elif (pepperman.is_in_group("obj_pepperman")):
		if (!pepperman.charging):
			queue_free()
