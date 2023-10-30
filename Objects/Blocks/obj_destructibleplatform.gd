extends StaticBody2D

var falling = false
var reset = 100

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0
	
func _process(delta):
	if ($Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1 && $Sprite.animation == "cheeseblock" && falling):
		$Collision.set_deferred("disabled", true)
		$Sprite.speed_scale = 0
		visible = false
	if (!visible):
		reset -= 1
	if (reset < 0 && !$PlayerCheck.overlaps_body(utils.get_player())):
		reset = 100
		visible = true
		$Sprite.speed_scale = 0.35
		falling = false
		$Collision.set_deferred("disabled", false)
		$Sprite.animation = "cheeseblockreform"
	if ($Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1 && $Sprite.animation == "cheeseblockreform"):
		$Sprite.animation = "cheeseblock"
		$Sprite.speed_scale = 0
	var obj_player = utils.get_player()
	if ($PlayerStandingCheck.overlaps_body(obj_player) && obj_player.is_on_floor() && $Sprite.animation == "cheeseblock"):
		falling = true
		if (falling):
			$Sprite.speed_scale = 0.35
