extends StaticBody2D

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()
	
func destroy():
	if (!global.saveroom.has(global.targetRoom + name)):
		global.saveroom.append(global.targetRoom + name)
	queue_free()

func _on_Sprite_animation_finished():
	destroy()

func _on_Button_body_entered(body):
	if body is obj_player:
		var obj_player = utils.get_player()
		if (obj_player.velocity.y < 0 && global.pizzacoin >= 4 && $Sprite.speed_scale == 0):
			utils.playsound("BuyWeapon")
			global.pizzacoin -= 4
			$Sprite.speed_scale = 0.35
