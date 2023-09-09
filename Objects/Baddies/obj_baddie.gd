class_name obj_baddie
extends KinematicBody2D

# This is a combination of obj_baddie and obj_baddiecollisionbox
# since having them seperately would be an absolute nightmare to work with

var important = 0
var spr_dead
var spr_scared
var spr_idle
var spr_stunfall
var spr_stunfalltrans
var spr_grabbed
var spr_hit
var spr_hitwall
var spr_flying
var spr_land
var spr_turn
var spr_walk
var state
var stun = false
var ministun = false
var stunned = 0
var attack = false
var movespeed = 0
const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var thrown = false
var straightthrow = false
var hp = 1
var grav = 0.5
var xscale = -1
var sprite_index
var screenvisible = false
onready var macheffecttimer = $MachEffectTimer
onready var bangeffecttimer = $BangEffectTimer

func _process(delta):
	sprite_index = $Sprite.animation
	screenvisible = $ScreenVisibility.is_on_screen()
	if (xscale == 1):
		$Sprite.flip_h = false
		$WallCheck.scale.x = 1
		$OppositeWallCheck.scale.x = 1
	elif (xscale == -1):
		$Sprite.flip_h = true
		$WallCheck.scale.x = -1
		$OppositeWallCheck.scale.x = -1
	position.x += velocity.x
	position.y += velocity.y
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("obj_solid"):
			if (state != global.states.grabbed):
				destroy()
		if collision.collider.is_in_group("obj_spike"):
			destroy()
		if collision.collider.is_in_group("obj_boilingsauce"):
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
						global.hit += 1
						global.combotime = 60
						if (!obj_player.is_on_floor() && obj_player.state != global.states.freefall && Input.is_action_just_pressed("key_jump")):
							if (obj_player.state == global.states.mach3 || obj_player.state == global.states.mach2):
								obj_player.set_animation("mach2jump")
							obj_player.suplexmove = 0
							obj_player.velocity.y = -11
						destroy()
					if (obj_player.global_position.y < global_position.y && obj_player.attacking == 0 && obj_player.sprite_index != "mach2jump" && (obj_player.state == global.states.jump || obj_player.state == global.states.mach1 || obj_player.state == global.states.grab) && obj_player.velocity.y >= 0 && velocity.y >= 0 && obj_player.sprite_index != "stompprep"):
						utils.get_gamenode().get_node(@"Stomp").play()
						state = global.states.stun
						if (stunned < 100):
							stunned = 100
						if Input.is_action_just_pressed("key_jump"):
							utils.instance_create(obj_player.global_position.x, (obj_player.global_position.y + 50), "res://Objects/Visuals/obj_stompeffect.tscn")
							obj_player.stompAnim = 1
							obj_player.velocity.y = -14
							if (obj_player.state != global.states.grab):
								obj_player.set_animation("stompprep")
						else:
							utils.instance_create(obj_player.global_position.x, (obj_player.global_position.y + 50), "res://Objects/Visuals/obj_stompeffect.tscn")
							obj_player.stompAnim = 1
							obj_player.velocity.y = -9
							if (obj_player.state != global.states.grab):
								obj_player.set_animation("stompprep")
					if (state != global.states.pizzagoblinthrow && velocity.y >= 0 && obj_player.state != global.states.tackle && obj_player.state != global.states.superslam && obj_player.state != global.states.machslide && obj_player.state != global.states.freefall && obj_player.state != global.states.mach2 && obj_player.state != global.states.handstandjump):
						utils.get_gamenode().get_node(@"Bump").play()
						if (obj_player.state != global.states.bombpep && obj_player.state != global.states.mach1):
							obj_player.movespeed = 0
						if (is_in_group("obj_pizzaball")):
							pass
							# global.golfhit += 1
						if (stunned < 100):
							stunned = 100
						velocity.y = -5
						velocity.x = (xscale * 2)
						state = global.states.stun
					if (obj_player.state == global.states.superslam || obj_player.state == global.states.freefall):
						utils.get_gamenode().get_node(@"HitEnemy").play()
						global.combotime = 60
						utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
						state = global.states.stun
						hp -= 1
						if (stunned < 100):
							stunned = 100
						utils.instance_create(obj_player.global_position.x, obj_player.global_position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
						utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_bangeffect.tscn")
						if (hp <= 0):
							stunned = 200
							state = global.states.stun
						obj_player.velocity.y = -7
						obj_player.state = global.states.normal
						velocity.y = -4
						velocity.x = (xscale * 5)
					if (obj_player.state == global.states.handstandjump && obj_player.character == "P"):
						if (obj_player.shotgunAnim == 0):
							obj_player.movespeed = 0
							obj_player.set_animation("haulingstart")
							obj_player.state = global.states.grab
							state = global.states.grabbed
						else:
							pass
							# insert code for shotgun
		if collision.collider.is_in_group("obj_baddie"):
			if (state == global.states.stun && thrown):
				destroy()
				collision.collider.destroy()
func _physics_process(delta):
	if (state != global.states.grabbed):
		velocity.y += grav
		velocity = move_and_slide(velocity, FLOOR_NORMAL, true)
		
func _ready():
	if (global.baddieroom.has(global.targetRoom + name)):
		queue_free()

func destroy():
	if (!global.baddieroom.has(global.targetRoom + name) && important == 0):
		var i = utils.randi_range(0, 100)
		#if (i >= 95):
			# insert code to play scream sfx here
		utils.get_gamenode().get_node(@"KillEnemy").play()
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
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
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		for obj in get_tree().get_nodes_in_group("obj_camera"):
			obj.shake_mag = 3
			obj.shake_mag_acc = (3 / 10)
		var deadbaddieid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_sausageman_dead.tscn")
		deadbaddieid.sprite_index = spr_dead

func _on_MachEffectTimer_timeout():
	var a = utils.randi_range(-20, 20)
	if (state == global.states.stun && velocity.x != 0 && thrown):
		$MachEffectTimer.wait_time = 0.083
		$MachEffectTimer.start()
	utils.instance_create(global_position.x + a, global_position.y + a, "res://Objects/Visuals/obj_machalleffect.tscn")

func _on_BangEffectTimer_timeout():
	utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_bangeffect.tscn")
	
# Enemy scripts
func scr_enemy_idle():
	if (velocity.y > 1 && is_on_floor()):
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_landcloud.tscn")
	if (velocity.y >= 0 && sprite_index == spr_scared && is_on_floor()):
		state = global.states.walk
	if (is_in_group("obj_ancho") && sprite_index == spr_scared && $Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1):
		state = global.states.walk
	if (is_in_group("obj_forknight") && sprite_index == "turn" && $Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1):
		state = global.states.walk
	if (is_on_floor() && velocity.y > 0):
		velocity.x = 0
	if (!is_on_floor() && velocity.x < 0):
		velocity.x += 0.1
	elif (!is_on_floor() && velocity.x > 0):
		velocity.x -= 0.1
	$Sprite.speed_scale = 0.35
	
func scr_enemy_walk():
	if (is_on_floor()):
		velocity.x = (xscale * movespeed)
	elif (!is_in_group("obj_ancho")):
		velocity.x = 0
	$Sprite.animation = spr_walk
	$Sprite.speed_scale = 0.35
	if ($WallCheck.is_colliding() && ($WallCheck.get_collider().is_in_group("obj_solid") || $WallCheck.get_collider().is_in_group("obj_hallway"))):
		if (is_in_group("obj_forknight")):
			xscale *= -1
			$Sprite.animation = "turn"
			state = global.states.idle
		else:
			xscale *= -1
	if (!is_in_group("obj_ancho")):
		if ($PlatformCheck.is_colliding() && $PlatformCheck.get_collider().is_in_group("obj_platform")):
			if (movespeed > 0 && is_on_floor()):
				if (is_in_group("obj_forknight")):
					xscale *= -1
					$Sprite.animation = "turn"
					state = global.states.idle
				else:
					xscale *= -1
					
func scr_enemy_turn():
	$Sprite.animation = spr_turn
	$Sprite.speed_scale = 0.35
	if ($Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1):
		state = global.states.idle
		$Sprite.animation = spr_idle
		xscale *= -1

func scr_enemy_stun():
	if (is_in_group("obj_ninja")):
		attack = true
	stunned -= 1
	$Sprite.animation = spr_stunfall
	$Sprite.speed_scale = 0.35
	if ((is_on_floor()) && velocity.y >= 0):
		if (thrown && hp <= 0):
			destroy()
		thrown = false
		grav = 0.5
		velocity.x = 0
	if ($OppositeWallCheck.is_colliding() && ($OppositeWallCheck.get_collider().is_in_group("obj_solid") && !$OppositeWallCheck.get_collider().is_in_group("obj_destructibles"))):
		var impactinst = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_bulletimpact.tscn")
		impactinst.xscale = -xscale
		if (thrown):
			destroy()
		thrown = false
		grav = 0.5
		xscale *= -1
		velocity.x = (-xscale * 4)
	if ($Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1 && stunned < 0):
		if (!is_in_group("obj_ancho") && !is_in_group("obj_pizzaboy")):
			velocity.y = -4
		else:
			velocity.y = 0
		$Sprite.animation = spr_walk
		state = global.states.walk
		movespeed = 1
		
func scr_enemy_land():
	if (velocity.y >= 0):
		velocity.x = 0
	$Sprite.animation = spr_land
	$Sprite.speed_scale = 0.35
	if ($Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1):
		$Sprite.animation = spr_idle
		state = global.states.idle
		
func scr_enemy_hit():
	if (straightthrow):
		velocity.y = 0
	if (velocity.y < 0 && $Sprite.frame != 2 && $Sprite.animation != spr_flying):
		$Sprite.animation = spr_hit
	elif (velocity.y < 0):
		$Sprite.animation = spr_flying
	elif ($Sprite.animation == spr_flying):
		$Sprite.animation = spr_stunfalltrans
	elif ($Sprite.frame == 4 && $Sprite.animation == spr_stunfalltrans):
		$Sprite.animation = spr_stunfall
	if (is_on_floor() && floor(velocity.y) >= 0):
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_landcloud.tscn")
		state = global.states.stun
		$Sprite.frame = 0
	$Sprite.speed_scale = 0.35
	
func scr_enemy_grabbed():
	var obj_player = utils.get_player()
	xscale = (-obj_player.xscale)
	stunned = 200
	obj_player.baddiegrabbed = name
	if (obj_player.state == global.states.grabbing || obj_player.state == global.states.grab || obj_player.state == global.states.throw || obj_player.state == global.states.slam):
		position.x = obj_player.position.x
		if (obj_player.sprite_index != "haulingstart"):
			position.y = (obj_player.position.y - 40)
		elif (floor(obj_player.get_sprite_frame) == 0):
			position.y = obj_player.position.y
		elif (floor(obj_player.get_sprite_frame) == 1):
			position.y = (obj_player.position.y - 10)
		elif (floor(obj_player.get_sprite_frame) == 2):
			position.y = (obj_player.position.y - 20)
		elif (floor(obj_player.get_sprite_frame) == 3):
			position.y = (obj_player.position.y - 30)
		xscale = (-obj_player.xscale)
	if (!(obj_player.state == global.states.grab || obj_player.state == global.states.finishingblow || obj_player.state == global.states.grabbing || obj_player.state == global.states.throw || obj_player.state == global.states.slam || obj_player.state == global.states.punch || obj_player.state == global.states.superslam || obj_player.state == global.states.backkick || obj_player.state == global.states.uppunch || obj_player.state == global.states.shoulder)):
		position.x = obj_player.position.x
		position.y = obj_player.position.y
		state = global.states.stun
		$Sprite.frame = 0
	velocity.x = 0
	if (obj_player.state == global.states.punch):
		$BangEffectTimer.wait_time = 0.05
		$BangEffectTimer.start()
		global.hit += 1
		if (is_in_group("obj_pizzaball")):
			global.golfhit += 1
		hp -= 1
		utils.instance_create((global_position.x + (obj_player.xscale * 30)), global_position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
		$MachEffectTimer.wait_time = 0.083
		$MachEffectTimer.start()
		thrown = true
		position.x = obj_player.position.x
		position.y = obj_player.position.y
		velocity.y = 0
		state = global.states.stun
		velocity.x = ((-xscale) * 25)
		grav = 0
		global.combotime = 60
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 3
			i.shake_mag_acc = (3 / 30)
	if (obj_player.state == global.states.finishingblow && obj_player.get_sprite_frame < 5):
		position.x = (obj_player.position.x + (obj_player.xscale * 60))
		position.y = obj_player.position.y
	if (obj_player.state == global.states.backkick):
		$BangEffectTimer.wait_time = 0.05
		$BangEffectTimer.start()
		global.hit += 1
		if (is_in_group("obj_pizzaball")):
			global.golfhit += 1
		hp -= 1
		utils.instance_create((global_position.x + ((-obj_player.xscale) * 50)), global_position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
		$MachEffectTimer.wait_time = 0.083
		$MachEffectTimer.start()
		thrown = true
		position.x = obj_player.position.x
		position.y = obj_player.position.y
		state = global.states.stun
		xscale *= -1
		velocity.y = -7
		velocity.x = ((-xscale) * 20)
		global.combotime = 60
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 3
			i.shake_mag_acc = (3 / 30)
	if ($WallCheck.is_colliding() && $WallCheck.get_collider().is_in_group("obj_swordhitbox")):
		hp -= 1
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 3
			i.shake_mag_acc = (3 / 30)
		$BangEffectTimer.wait_time = 0.05
		$BangEffectTimer.start()
		global.hit += 1
		if (is_in_group("obj_pizzaball")):
			global.golfhit += 1
		$MachEffectTimer.wait_time = 0.083
		$MachEffectTimer.start()
		thrown = true
		state = global.states.stun
		if (obj_player.sprite_index == "uppercutfinishingblow"):
			velocity.x = 0
			velocity.y = -25
		else:
			velocity.x = ((-xscale) * 25)
			velocity.y = -6
	if (obj_player.state == global.states.throw):
		global.hit += 1
		if (is_in_group("obj_pizzaball")):
			global.golfhit += 1
		$MachEffectTimer.wait_time = 0.083
		$MachEffectTimer.start()
		thrown = true
		position.x = obj_player.position.x
		position.y = obj_player.position.y
		state = global.states.stun
		velocity.x = ((-xscale) * 8)
		velocity.y = -6
	if (obj_player.state == global.states.uppunch):
		$BangEffectTimer.wait_time = 0.05
		$BangEffectTimer.start()
		global.hit += 1
		if (is_in_group("obj_pizzaball")):
			global.golfhit += 1
		hp -= 1
		utils.instance_create((global_position.x + ((-obj_player.xscale) * 15)), (global_position.y - 50), "res://Objects/Visuals/obj_bumpeffect.tscn")
		$MachEffectTimer.wait_time = 0.083
		$MachEffectTimer.start()
		thrown = true
		position.x = obj_player.position.x
		position.y = obj_player.position.y
		state = global.states.stun
		velocity.y = -20
		velocity.x = ((-xscale) * 2)
		global.combotime = 60
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 3
			i.shake_mag_acc = (3 / 30)
	if ((obj_player.state == global.states.superslam && obj_player.sprite_index == "piledriver") || (obj_player.state == global.states.grab && obj_player.sprite_index == "swingding")):
		if (obj_player.character == "P"):
			if (floor(obj_player.get_sprite_frame) == 0):
				z_index = 0
				position.x = (obj_player.position.x + (obj_player.xscale * 10))
				position.y = obj_player.position.y
			if (floor(obj_player.get_sprite_frame) == 1):
				z_index = 0
				position.x = (obj_player.position.x + (obj_player.xscale * 5))
				position.y = obj_player.position.y
			if (floor(obj_player.get_sprite_frame) == 2):
				z_index = 0
				position.x = obj_player.position.x
				position.y = obj_player.position.y
			if (floor(obj_player.get_sprite_frame) == 3):
				z_index = 0
				position.x = (obj_player.position.x + (obj_player.xscale * -5))
				position.y = obj_player.position.y
			if (floor(obj_player.get_sprite_frame) == 4):
				z_index = 0
				position.x = (obj_player.position.x + (obj_player.xscale * -10))
				position.y = obj_player.position.y
			if (floor(obj_player.get_sprite_frame) == 5):
				z_index = 8
				position.x = (obj_player.position.x + (obj_player.xscale * -5))
				position.y = obj_player.position.y
			if (floor(obj_player.get_sprite_frame) == 6):
				z_index = 8
				position.x = obj_player.position.x
				position.y = obj_player.position.y
			if (floor(obj_player.get_sprite_frame) == 7):
				z_index = 8
				position.x = (obj_player.position.x + (obj_player.xscale * 5))
				position.y = obj_player.position.y
		else:
			z_index = 7
			position.x = obj_player.position.x
			position.y = (obj_player.position.y - 40)
	$Sprite.animation = spr_grabbed
	$Sprite.speed_scale = 0.35
