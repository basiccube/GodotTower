extends Area2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	z_index = -1

func _process(delta):
	if (overlaps_body(utils.get_player())):
		utils.get_player().destroy(get_node("."))
	for i in get_overlapping_bodies():
		if i.is_in_group("obj_baddie"):
			i.destroy()
