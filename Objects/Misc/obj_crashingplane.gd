extends Node2D

var hspeed = -1
var vspeed = 6

func _ready():
	$Sprite.speed_scale = 0.35
	$Sprite.playing = true
	
func _process(delta):
	position.x += hspeed
	position.y += vspeed
	if (position.y > 750):
		for obj in get_tree().get_nodes_in_group("obj_camera"):
			obj.shake_mag = 20
			obj.shake_mag_acc = 0.5
		queue_free()
