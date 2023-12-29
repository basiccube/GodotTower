extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var grav = 0.5

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()
		
func destroy():
	global.saveroom.append(global.targetRoom + name)
	queue_free()

func _process(delta):
	position.x += velocity.x
	position.y += velocity.y
	
func _physics_process(delta):
	velocity.y += grav
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)

func _on_CollectArea_body_entered(body):
	if body is obj_player:
		var obj_player = utils.get_player()
		if (obj_player.shotgunAnim == 0 && !obj_player.backupweapon && (obj_player.state == global.states.handstandjump || obj_player.state == global.states.spin)):
			obj_player.shotgunAnim = 1
			obj_player.state = global.states.shotgun
			obj_player.set_animation("shotgun_pullout")
			utils.playsound("ShotgunGot")
			destroy()
		elif (obj_player.shotgunAnim == 1 && !obj_player.backupweapon && (obj_player.state == global.states.handstandjump || obj_player.state == global.states.spin)):
			obj_player.backupweapon = true
			destroy()
