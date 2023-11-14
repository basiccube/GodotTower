extends Node2D

var velocity = Vector2.ZERO
var grav = 0.4
var cigar = false
var stomped = false
var sprite_index = load("res://Objects/Baddies/sprites/sausageman/sausageman_shot_0.png")

func _ready():
	velocity.y = utils.randi_range(-5, -10)
	velocity.x = (utils.get_player().xscale * utils.randi_range(5, 10))
	$MachAllTimer.wait_time = 0.083
	$MachAllTimer.start()
	if (position.x != utils.get_player().position.x):
		if (utils.get_player().xscale == 1):
			$Sprite.flip_h = true
		elif (utils.get_player().xscale == -1):
			$Sprite.flip_h = false
			
func _process(delta):
	$Sprite.texture = sprite_index
	if (velocity.y < 20):
		velocity.y += grav
	position.x += velocity.x
	position.y += floor(velocity.y)
	if (!$CamVisibility.is_on_screen()):
		queue_free()

func _on_MachAllTimer_timeout():
	var a = utils.randi_range(-40, 40)
	$MachAllTimer.wait_time = 0.083
	$MachAllTimer.start()
	utils.instance_create((position.x + a), (position.y + a), "res://Objects/Visuals/obj_machalleffect.tscn")
