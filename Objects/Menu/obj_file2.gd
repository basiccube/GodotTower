extends Node2D

onready var sprite = $Sprite

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	
func _process(delta):
	var obj_mainmenuselect = utils.get_instance_level("obj_mainmenuselect")
	if (obj_mainmenuselect.optionselected == 1):
		$Sprite.animation = "file2"
	else:
		$Sprite.animation = "file2empty"
