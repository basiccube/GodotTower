extends Node2D

var show = 0

func _ready():
	$PizzacoinSprite.playing = true
	$PizzacoinSprite.speed_scale = 0.35
	
func _process(delta):
	if (!get_tree().get_nodes_in_group("obj_weaponmachine").empty()):
		visible = true
	elif (show == 0):
		visible = false
	if (show > 0):
		show -= 1
		visible = true
	$PizzacoinCounter.text = str(global.pizzacoin)
	var obj_player = utils.get_player()
	position.x = obj_player.position.x + 15
	position.y = obj_player.position.y - 10
