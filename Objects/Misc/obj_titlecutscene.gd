extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var grav = 0.5
var drop = false

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35

func _process(delta):
	if (drop):
		velocity.x = 8
		position.x += velocity.x
		position.y += velocity.y
		velocity.y += grav
		velocity = move_and_slide(velocity, FLOOR_NORMAL, true)
	if (position.x > 960 && !utils.instance_exists("obj_fadeout")):
		utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_fadeout.tscn")
		utils.get_player().targetRoom = "Titlescreen"
	if ($Sprite.animation == "pepcooter" && !utils.instance_exists("obj_superdashcloud")):
		utils.instance_create(position.x - 120, position.y - 50, "res://Objects/Visuals/obj_superdashcloud.tscn")

func rockcollision():
	var obj_rockcutscene = utils.get_instance_level("obj_rockcutscene")
	if (obj_rockcutscene.frame == 0):
		utils.playsound("PepHurt")
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bangeffect.tscn")
		$Sprite.animation = "machfreefall"
		drop = true
		velocity.y = -20
		velocity.x = 8
		obj_rockcutscene.frame = 1
		obj_rockcutscene.velocity.x = -20
				
