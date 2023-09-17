tool
extends StaticBody2D

export(bool) var Reverse = false

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	z_index = 1
	
func _process(delta):
	if Engine.editor_hint:
		if (!Reverse):
			$Sprite.animation = "sleep"
		else:
			$Sprite.animation = "woke"
	else:
		if (!Reverse):
			if (!global.panic):
				$Sprite.animation = "sleep"
				$Collision.set_deferred("disabled", true)
			else:
				$Sprite.animation = "woke"
				$Collision.set_deferred("disabled", false)
		else:
			if (!global.panic):
				$Sprite.animation = "woke"
				$Collision.set_deferred("disabled", false)
			else:
				$Sprite.animation = "sleep"
				$Collision.set_deferred("disabled", true)
