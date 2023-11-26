extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var grav = 0.4

func _ready():
	$Sprite.playing = true
	$Sprite.speed_scale = 0.35
	
func destroy():
	var debris1 = utils.instance_create_level(global_position.x, global_position.y, "res://Objects/Visuals/obj_debris.tscn")
	debris1.sprite_index = "slimedebris"
	var debris2 = utils.instance_create_level(global_position.x, global_position.y, "res://Objects/Visuals/obj_debris.tscn")
	debris2.sprite_index = "slimedebris"
	var debris3 = utils.instance_create_level(global_position.x, global_position.y, "res://Objects/Visuals/obj_debris.tscn")
	debris3.sprite_index = "slimedebris"
	queue_free()

func _process(delta):
	position.x += velocity.x
	position.y += velocity.y
	if (is_on_floor() && velocity.y >= 0):
		destroy()
	if (!$ScreenVisibility.is_on_screen()):
		destroy()
	if ($CollisionArea.overlaps_body(utils.get_player())):
		utils.get_player().destroy(get_node("."))
	
func _physics_process(delta):
	if (velocity.y < 12):
		velocity.y += grav
	velocity = move_and_slide(velocity, FLOOR_NORMAL, true)
