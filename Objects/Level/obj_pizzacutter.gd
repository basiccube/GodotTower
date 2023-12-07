extends Area2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35

func _process(delta):
	rotation_degrees -= 4
	var obj_player = utils.get_player()
	if (overlaps_body(obj_player)):
		obj_player.destroy(get_node("."))
