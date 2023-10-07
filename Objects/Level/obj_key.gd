extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var grav = 0.4
var inv_frame = false

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	if (global.saveroom.has(global.targetRoom + name)):
		queue_free()
	if (global.key_inv):
		velocity.y = -15
		velocity.x = utils.randi_range(-4, 4)
		destroy()
		
func _process(delta):
	if (velocity.y < 12):
		velocity.y += grav
	if (inv_frame):
		modulate.a = 0.5
	else:
		modulate.a = 1
	position.x += velocity.x
	position.y += velocity.y
		
func _physics_process(delta):
	velocity.y += grav
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)

func destroy():
	global.saveroom.append(global.targetRoom + name)
	queue_free()

func _on_CollectArea_body_entered(body):
	if body is obj_player:
		var obj_player = utils.get_player()
		if (!inv_frame
		&& obj_player.state != global.states.bombpep
		&& obj_player.state != global.states.knightpep
		&& obj_player.state != global.states.cheeseball
		&& obj_player.state != global.states.cheesepep
		&& obj_player.state != global.states.knightpepattack
		&& obj_player.state != global.states.knightpepslopes
		&& obj_player.state != global.states.hurt):
			global.key_inv = true
			for i in 5:
				utils.instance_create(utils.randi_range((obj_player.position.x + 50) + 25, (obj_player.position.x + 50) - 25), utils.randi_range((obj_player.position.y + 50) + 35, (obj_player.position.y + 50) - 25), "res://Objects/Visuals/obj_keyeffect.tscn")
			utils.playsound("CollectToppin")
			if (!global.keyget):
				obj_player.state = global.states.keyget
				global.keyget = true
			destroy()
