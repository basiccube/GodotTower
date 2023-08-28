class_name obj_baddie
extends KinematicBody2D

# This is a combination of obj_baddie and obj_baddiecollisionbox
# since having them seperately would be an absolute nightmare to work with

var important = 0
var spr_dead
var state
const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var thrown = 0
var grav = 0.5
onready var macheffecttimer = $MachEffectTimer
onready var bangeffecttimer = $BangEffectTimer

func _process(delta):
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("obj_solid"):
			if (state != global.states.grabbed):
				destroy()
		if collision.collider.is_in_group("obj_player"):
			if (state != global.states.grabbed):
				for obj_player in get_tree().get_nodes_in_group("obj_player"):
					if (obj_player.instakillmove == 1):
						if (obj_player.state == global.states.mach3 && obj_player.sprite_index != "mach3hit"):
							obj_player.set_animation("mach3hit")
						if (obj_player.state == global.states.mach2 && obj_player.is_on_floor()):
							obj_player.machpunchAnim = 1
						utils.get_gamenode().get_node(@"Punch").play()
						destroy()
func _physics_process(delta):
	if (state != global.states.grabbed):
		velocity.y += grav
		velocity = move_and_slide(velocity, FLOOR_NORMAL, true)

func destroy():
	if (!global.baddieroom.has(global.targetRoom + name) && important == 0):
		var i = utils.randi_range(0, 100)
		#if (i >= 95):
			# insert code to play scream sfx here
		utils.get_gamenode().get_node(@"KillEnemy").play()
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_baddiegibs.tscn")
		for obj in get_tree().get_nodes_in_group("obj_camera"):
			obj.shake_mag = 3
			obj.shake_mag_acc = (3 / 10)
		var deadbaddieid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_sausageman_dead.tscn")
		deadbaddieid.sprite_index = spr_dead
		global.baddieroom.append(global.targetRoom + name)
		for obj in get_tree().get_nodes_in_group("obj_tv"):
			obj.frame = utils.randi_range(0, 4)
		global.combo += 1
		if (global.combo == 1):
			global.collect += 10
			var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
			smallnumbid.number = "10"
		if (global.combo == 2):
			global.collect += 20
			var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
			smallnumbid.number = "20"
		if (global.combo == 3):
			global.collect += 40
			var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
			smallnumbid.number = "40"
		if (global.combo >= 4):
			global.collect += 80
			var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
			smallnumbid.number = "80"
		global.combotime = 60
	elif (!global.baddieroom.has(global.targetRoom + name) && important == 1):
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_baddiegibs.tscn")
		for obj in get_tree().get_nodes_in_group("obj_camera"):
			obj.shake_mag = 3
			obj.shake_mag_acc = (3 / 10)
		var deadbaddieid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_sausageman_dead.tscn")
		deadbaddieid.sprite_index = spr_dead

func _on_MachEffectTimer_timeout():
	var a = utils.randi_range(-20, 20)
	if (state == global.states.stun && velocity.x != 0 && thrown == 1):
		$MachEffectTimer.wait_time = 0.083
		$MachEffectTimer.start()
	utils.instance_create(global_position.x + a, global_position.y + a, "res://Objects/Visuals/obj_machalleffect.tscn")

func _on_BangEffectTimer_timeout():
	utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_bangeffect.tscn")
