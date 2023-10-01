extends Area2D

func _ready():
	$Sprite.playing = true

func _process(delta):
	position.y += 15
	var obj_player = utils.get_player()
	if (overlaps_body(obj_player)):
		obj_player.set_animation("knightpep_thunder")
		utils.playsound("BecomeKnight")
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 10
			i.shake_mag_acc = (30 / 30)
		queue_free()
