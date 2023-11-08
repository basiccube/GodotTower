extends Node2D

var sprite = load("res://Objects/Baddies/sprites/sausageman/sausageman_shot_0.png")

func _ready():
	$Timer.start()
	
func _process(delta):
	position.x += utils.randi_range(-5, 5)
	position.y += utils.randi_range(-5, 5)

func _on_Timer_timeout():
	var dead = utils.instance_create(position.x, position.y, "res://Objects/Baddies/obj_sausageman_dead.tscn")
	utils.playsound("KillEnemy")
	dead.sprite_index = $Sprite.texture
	queue_free()
