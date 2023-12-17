class_name obj_baddie
extends KinematicBody2D

# This is a combination of obj_baddie and obj_baddiecollisionbox
# since having them seperately would be an absolute nightmare to work with
# Most of obj_baddiecollisionbox's code is in obj_player anyway

var important = false
var spr_dead
var spr_scared
var spr_idle
var spr_fall
var spr_stunfall
var spr_stunfalltrans
var spr_grabbed
var spr_recovery
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
var momentum = 0
var palette = 0
const FLOOR_NORMAL = Vector2.UP
var velocity = Vector2.ZERO
var thrown = false
var straightthrow = false
var hp = 1
var grav = 0.5
var bombreset = 0
export(int) var xscale = -1
var sprite_index
var screenvisible = false
onready var macheffecttimer = $MachEffectTimer
onready var bangeffecttimer = $BangEffectTimer

func _process(delta):
	sprite_index = $Sprite.animation
	$Sprite.playing = true
	if ($Sprite.material != null):
		$Sprite.material.set_shader_param("current_palette", palette)
	screenvisible = $ScreenVisibility.is_on_screen()
	if (state == global.states.grabbed && utils.get_player().state != global.states.finishingblow):
		$Collision.set_deferred("disabled", true)
	else:
		$Collision.set_deferred("disabled", false)
	if (xscale == 1):
		$Sprite.flip_h = false
		$WallCheck.scale.x = 1
		$WallCheck2.scale.x = 1
		$WallCheck3.scale.x = 1
		$OppositeWallCheck.scale.x = 1
		$PlatformCheck.position.x = 16
		$SlopeCheck.position.x = -8
	elif (xscale == -1):
		$Sprite.flip_h = true
		$WallCheck.scale.x = -1
		$WallCheck2.scale.x = -1
		$WallCheck3.scale.x = -1
		$OppositeWallCheck.scale.x = -1
		$PlatformCheck.position.x = -16
		$SlopeCheck.position.x = 8
	position.x += velocity.x
	position.y += velocity.y
	velocity.x = clamp(velocity.x, -50, 50)
	velocity.y = clamp(velocity.y, -50, 50)
	if (global.baddierage):
		palette = 1
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if (collision.collider != null):
			if collision.collider.is_in_group("obj_shotgunbullet"):
				if (hp <= 1):
					collision.collider.destroy()
					destroy()
				else:
					hp -= 1
					utils.playsound("HitEnemy")
					utils.playsound("Punch")
					global.hit += 1
					global.combotime = 60
					global.heattime = 60
					global.heatstyle += 5
					utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
					utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
					state = global.states.stun
					if (stunned < 100):
						stunned = 100
					utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
					utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_bangeffect.tscn")
					velocity.y = -4
					velocity.x = collision.collider.scale.x * 5
			if (collision.collider.is_in_group("obj_destructibles") && !collision.collider.is_in_group("obj_specialdestructibles")):
				if (state == global.states.stun && thrown):
					collision.collider.destroy()
			if collision.collider.is_in_group("obj_baddie"):
				if (state == global.states.stun && thrown):
					destroy()
					collision.collider.destroy()
			if collision.collider.is_in_group("obj_player"):
				var obj_player = utils.get_player()
				if (state != global.states.pizzagoblinthrow && velocity.y >= 0 && obj_player.state != global.states.tackle && obj_player.state != global.states.superslam && obj_player.state != global.states.machslide && obj_player.state != global.states.freefall && obj_player.state != global.states.mach2 && obj_player.state != global.states.handstandjump && obj_player.state != global.states.mach3 && obj_player.state != global.states.machroll && obj_player.state != global.states.shoulderbash):
					utils.playsound("Bump")
					if (obj_player.state != global.states.bombpep && obj_player.state != global.states.mach1):
						obj_player.movespeed = 0
					if (is_in_group("obj_pizzaball")):
						global.golfhit += 1
					if (stunned < 100):
						stunned = 100
					velocity.y = -5
					velocity.x = ((-xscale) * 5)
					state = global.states.stun
			if collision.collider.is_in_group("obj_boilingsauce"):
				destroy()

func _physics_process(delta):
	if (state != global.states.grabbed):
		if (velocity.y < 30):
			velocity.y += grav
		velocity = move_and_slide(velocity, FLOOR_NORMAL, false)
		
func _ready():
	if (global.baddieroom.has(global.targetRoom + name)):
		queue_free()

func destroy():
	if (!global.baddieroom.has(global.targetRoom + name) && !important):
		var i = utils.randi_range(0, 100)
		if (i >= 90):
			if (i == 90):
				utils.playsound("Scream1")
			if (i == 91):
				utils.playsound("Scream2")
			if (i == 92):
				utils.playsound("Scream3")
			if (i == 93):
				utils.playsound("Scream4")
			if (i == 94):
				utils.playsound("Scream5")
			if (i == 95):
				utils.playsound("Scream6")
			if (i == 96):
				utils.playsound("Scream7")
			if (i == 97):
				utils.playsound("Scream8")
			if (i == 98):
				utils.playsound("Scream9")
			if (i == 99):
				utils.playsound("Scream10")
		utils.playsound("KillEnemy")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		for obj in get_tree().get_nodes_in_group("obj_camera"):
			obj.shake_mag = 3
			obj.shake_mag_acc = 0.1
		var deadbaddieid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_sausageman_dead.tscn")
		if ($Sprite.material != null):
			deadbaddieid.get_node("Sprite").set_material($Sprite.material.duplicate(true))
		deadbaddieid.sprite_index = $Sprite.frames.get_frame(spr_dead, 0)
		global.baddieroom.append(global.targetRoom + name)
		for obj in get_tree().get_nodes_in_group("obj_tv"):
			obj.sprite.frame = utils.randi_range(0, 4)
		global.combo += 1
		global.heattime = 60
		global.heatstyle += 5
		if (global.combo <= 8):
			global.collect += 10
			var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
			smallnumbid.number = "10"
		if (global.combo > 8 && global.combo <= 16):
			global.collect += 20
			var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
			smallnumbid.number = "20"
		if (global.combo > 16 && global.combo <= 32):
			global.collect += 40
			var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
			smallnumbid.number = "40"
		if (global.combo > 32):
			global.collect += 80
			var smallnumbid = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_smallnumber.tscn")
			smallnumbid.number = "80"
		global.combotime = 60
		global.style += 5
	elif (!global.baddieroom.has(global.targetRoom + name) && important):
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
		deadbaddieid.sprite_index = $Sprite.frames.get_frame(spr_dead, 0)
	queue_free()
	
func is_colliding_with_wall():
	if (($WallCheck.is_colliding() && $WallCheck.get_collider() != null && ($WallCheck.get_collider().is_in_group("obj_solid") || $WallCheck.get_collider().is_in_group("obj_destructibles") || $WallCheck.get_collider().is_in_group("obj_metalblock") || $WallCheck.get_collider().is_in_group("obj_baddie") || $WallCheck.get_collider().is_in_group("obj_hungrypillar"))) ||
	($WallCheck2.is_colliding() && $WallCheck2.get_collider() != null && ($WallCheck2.get_collider().is_in_group("obj_solid") || $WallCheck2.get_collider().is_in_group("obj_destructibles") || $WallCheck2.get_collider().is_in_group("obj_metalblock") || $WallCheck2.get_collider().is_in_group("obj_baddie") || $WallCheck2.get_collider().is_in_group("obj_hungrypillar"))) ||
	($WallCheck3.is_colliding() && $WallCheck3.get_collider() != null && ($WallCheck3.get_collider().is_in_group("obj_solid") || $WallCheck3.get_collider().is_in_group("obj_destructibles") || $WallCheck3.get_collider().is_in_group("obj_metalblock") || $WallCheck3.get_collider().is_in_group("obj_baddie") || $WallCheck3.get_collider().is_in_group("obj_hungrypillar")))):
		return true
	else:
		return false
		
func is_colliding_with_solid():
	if (($WallCheck.is_colliding() && $WallCheck.get_collider() != null && $WallCheck.get_collider().is_in_group("obj_solid")) ||
	($WallCheck2.is_colliding() && $WallCheck2.get_collider() != null && $WallCheck2.get_collider().is_in_group("obj_solid")) ||
	($WallCheck3.is_colliding() && $WallCheck3.get_collider() != null && $WallCheck3.get_collider().is_in_group("obj_solid"))):
		return true
	else:
		return false

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
	if (is_on_floor() && velocity.y >= 0):
		velocity.x = 0
	if (!is_on_floor() && velocity.x < 0):
		velocity.x += 0.1
	elif (!is_on_floor() && velocity.x > 0):
		velocity.x -= 0.1
	$Sprite.speed_scale = 0.35
	
func scr_enemy_walk():
	if (is_on_floor()):
		velocity.x = (xscale * (movespeed + (global.baddiespeed - 1)))
	elif (!is_in_group("obj_ancho")):
		velocity.x = 0
	$Sprite.animation = spr_walk
	$Sprite.speed_scale = 0.35 + (global.baddiespeed * 0.05)
	if (is_colliding_with_wall()):
		if (is_in_group("obj_forknight")):
			xscale *= -1
			$Sprite.animation = "turn"
			state = global.states.idle
		else:
			$WallCheck.scale.x *= -1
			$WallCheck2.scale.x *= -1
			$WallCheck3.scale.x *= -1
			$OppositeWallCheck.scale.x *= -1
			$PlatformCheck.position.x *= -1
			$SlopeCheck.position.x *= -1
			xscale *= -1
	if (!is_in_group("obj_ancho")):
		if (!$PlatformCheck.is_colliding() && (!$SlopeCheck.is_colliding() || !$SlopeCheck.get_collider().is_in_group("obj_slope"))):
			if (movespeed > 0 && is_on_floor()):
				if (is_in_group("obj_forknight")):
					xscale *= -1
					$Sprite.animation = "turn"
					state = global.states.idle
				else:
					xscale *= -1
	else:
		velocity.y = 0
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
	match global.heatstylethreshold:
		0:
			stunned -= 1
		1:
			stunned -= 1.5
		2:
			stunned -= 1.65
		3:
			stunned -= 1.8
	$Sprite.animation = spr_stunfall
	$Sprite.speed_scale = 0.35
	if (((is_on_floor() && $FloorCheck.is_colliding()) || is_on_ceiling() || is_colliding_with_solid()) && velocity.y >= 0):
		if (thrown && hp <= 0):
			destroy()
		thrown = false
		grav = 0.5
		velocity.x = 0
	if ($OppositeWallCheck.is_colliding() && ($OppositeWallCheck.get_collider().is_in_group("obj_solid") && !$OppositeWallCheck.get_collider().is_in_group("obj_destructibles"))):
		var impactinst = utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_bulletimpact.tscn")
		impactinst.scale.x = -xscale
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
		if (!is_in_group("obj_spitcheese")):
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
			if (obj_player.character == "P"):
				position.y = (obj_player.position.y - 60)
			else:
				position.y = (obj_player.position.y - 50)
		elif (floor(obj_player.get_frame()) == 0):
			position.y = obj_player.position.y - 20
		elif (floor(obj_player.get_frame()) == 1):
			position.y = (obj_player.position.y - 30)
		elif (floor(obj_player.get_frame()) == 2):
			position.y = (obj_player.position.y - 40)
		elif (floor(obj_player.get_frame()) == 3):
			position.y = (obj_player.position.y - 50)
		xscale = (-obj_player.xscale)
	if (!(obj_player.state == global.states.grab || obj_player.state == global.states.finishingblow || obj_player.state == global.states.grabbing || obj_player.state == global.states.throw || obj_player.state == global.states.slam || obj_player.state == global.states.punch || obj_player.state == global.states.superslam || obj_player.state == global.states.backkick || obj_player.state == global.states.uppunch || obj_player.state == global.states.shoulder)):
		position.x = (obj_player.position.x + (50 * obj_player.xscale))
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
		global.heattime = 60
		if (!important):
			global.heatstyle += 5
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 3
			i.shake_mag_acc = (3 / 30)
	if (obj_player.state == global.states.finishingblow && obj_player.get_frame() < 5):
		if (obj_player.xscale == 1):
			position.x = (obj_player.position.x + 50)
		elif (obj_player.xscale == -1):
			position.x = (obj_player.position.x - 50)
		position.y = (obj_player.position.y - 10)
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
		global.heattime = 60
		if (!important):
			global.heatstyle += 5
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 3
			i.shake_mag_acc = (3 / 30)
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
		utils.instance_create((global_position.x + ((-obj_player.xscale) * 15)), global_position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
		$MachEffectTimer.wait_time = 0.083
		$MachEffectTimer.start()
		thrown = true
		position.x = obj_player.position.x
		position.y = obj_player.position.y
		state = global.states.stun
		velocity.y = -20
		velocity.x = ((-xscale) * 2)
		global.combotime = 60
		global.heattime = 60
		if (!important):
			global.heatstyle += 5
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 3
			i.shake_mag_acc = (3 / 30)
	if ((obj_player.state == global.states.superslam && obj_player.sprite_index == "piledriver") || (obj_player.state == global.states.grab && obj_player.sprite_index == "swingding")):
		if (obj_player.character == "P"):
			if (floor(obj_player.get_frame()) == 0):
				z_index = 0
				position.x = (obj_player.position.x + (obj_player.xscale * 10))
				position.y = (obj_player.position.y)
			if (floor(obj_player.get_frame()) == 1):
				z_index = 0
				position.x = (obj_player.position.x + (obj_player.xscale * 5))
				position.y = (obj_player.position.y)
			if (floor(obj_player.get_frame()) == 2):
				z_index = 0
				position.x = obj_player.position.x
				position.y = (obj_player.position.y)
			if (floor(obj_player.get_frame()) == 3):
				z_index = 0
				position.x = (obj_player.position.x + (obj_player.xscale * -5))
				position.y = (obj_player.position.y)
			if (floor(obj_player.get_frame()) == 4):
				z_index = 0
				position.x = (obj_player.position.x + (obj_player.xscale * -10))
				position.y = (obj_player.position.y)
			if (floor(obj_player.get_frame()) == 5):
				z_index = 8
				position.x = (obj_player.position.x + (obj_player.xscale * -5))
				position.y = (obj_player.position.y)
			if (floor(obj_player.get_frame()) == 6):
				z_index = 8
				position.x = obj_player.position.x
				position.y = (obj_player.position.y)
			if (floor(obj_player.get_frame()) == 7):
				z_index = 8
				position.x = (obj_player.position.x + (obj_player.xscale * 5))
				position.y = (obj_player.position.y)
		else:
			z_index = 7
			position.x = (obj_player.position.x + (5 * obj_player.xscale))
			position.y = (obj_player.position.y - 10)
	if (obj_player.sprite_index == "piledriverland" && $Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1):
		obj_player.state = global.states.jump
		obj_player.velocity.y = -8
		obj_player.set_animation("machfreefall")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_slapstar.tscn")
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
		global.combotime = 60
		global.heattime = 60
		if (!important):
			global.heatstyle += 5
		global.hit += 1
		hp -= 5
		$MachEffectTimer.wait_time = 0.083
		$MachEffectTimer.start()
		thrown = true
		position.x = (obj_player.position.x)
		position.y = (obj_player.position.y - 60)
		state = global.states.stun
		velocity.x = ((-xscale) * 10)
		velocity.y = -10
	if (obj_player.state == global.states.grab && obj_player.sprite_index == "swingding"):
		if (obj_player.character == "P" || obj_player.character == "N"):
			if (floor(obj_player.get_frame()) == 0):
				z_index = 8
				position.x = (obj_player.position.x + (obj_player.xscale * 25))
				position.y = obj_player.position.y
			if (floor(obj_player.get_frame()) == 1):
				z_index = 8
				position.x = obj_player.position.x
				position.y = obj_player.position.y
			if (floor(obj_player.get_frame()) == 2):
				z_index = 8
				position.x = (obj_player.position.x + (obj_player.xscale * -25))
				position.y = obj_player.position.y
			if (floor(obj_player.get_frame()) == 3):
				z_index = 0
				position.x = (obj_player.position.x + (obj_player.xscale * -50))
				position.y = obj_player.position.y
			if (floor(obj_player.get_frame()) == 4):
				z_index = 0
				position.x = (obj_player.position.x + (obj_player.xscale * -25))
				position.y = obj_player.position.y
			if (floor(obj_player.get_frame()) == 5):
				z_index = 0
				position.x = obj_player.position.x
				position.y = obj_player.position.y
			if (floor(obj_player.get_frame()) == 6):
				z_index = 0
				position.x = (obj_player.position.x + (obj_player.xscale * 25))
				position.y = obj_player.position.y
			if (floor(obj_player.get_frame()) == 7):
				z_index = 0
				position.x = (obj_player.position.x + (obj_player.xscale * 50))
				position.y = obj_player.position.y
		else:
			z_index = 7
			position.x = obj_player.position.x
			position.y = (obj_player.position.y - 10)
	$Sprite.animation = spr_grabbed
	$Sprite.speed_scale = 0.35
	
func scr_enemy_charge():
	if (is_in_group("obj_peasanto")):
		if (is_on_floor()):
			velocity.x = (xscale * (movespeed * 4))
		else:
			velocity.x = 0
		$Sprite.speed_scale = 0.35
		if (is_colliding_with_wall()):
			$WallCheck.scale.x *= -1
			$WallCheck2.scale.x *= -1
			$WallCheck3.scale.x *= -1
			$OppositeWallCheck.scale.x *= -1
			$PlatformCheck.position.x *= -1
			$SlopeCheck.position.x *= -1
			xscale *= -1
		if (!$PlatformCheck.is_colliding() && movespeed > 0):
			xscale *= -1
		if (!is_on_floor() && velocity.x < 0):
			velocity.x += 0.1
		elif (!is_on_floor() && velocity.x > 0):
			velocity.x -= 0.1
		$Sprite.animation = "attack"
	if (is_in_group("obj_fencer")):
		if (is_on_floor()):
			velocity.x = (xscale * movespeed)
		else:
			velocity.x = 0
		if (is_colliding_with_wall()):
			$WallCheck.scale.x *= -1
			$WallCheck2.scale.x *= -1
			$WallCheck3.scale.x *= -1
			$OppositeWallCheck.scale.x *= -1
			$PlatformCheck.position.x *= -1
			$SlopeCheck.position.x *= -1
			xscale *= -1
	if (is_in_group("obj_ancho")):
		velocity.x = (xscale * movespeed)
		velocity.y = 0
		if (is_colliding_with_wall()):
			state = global.states.stun
			stunned = 100
			
func scr_pizzagoblin_throw():
	var throw_frame = 0
	var throw_sprite = "throw"
	var reset_timer = 0
	if (is_in_group("obj_pizzagoblin")):
		throw_frame = 2
		throw_sprite = "throwbomb"
		reset_timer = 200
	elif (is_in_group("obj_cheeserobot")):
		throw_frame = 6
		throw_sprite = "attack"
		reset_timer = 200
	elif (is_in_group("obj_spitcheese")):
		throw_frame = 2
		throw_sprite = "spit"
		reset_timer = 100
	elif (is_in_group("obj_trash")):
		throw_frame = 2
		throw_sprite = "throw"
		reset_timer = 100
	elif (is_in_group("obj_invtrash")):
		throw_frame = 2
		throw_sprite = "throw"
		reset_timer = 100
	elif (is_in_group("obj_robot")):
		throw_frame = 2
		throw_sprite = "attack"
		reset_timer = 200
	elif (is_in_group("obj_kentukykenny")):
		throw_frame = 8
		throw_sprite = "throw"
		reset_timer = 200
	elif (is_in_group("obj_pizzard")):
		throw_frame = 6
		throw_sprite = "shoot"
		reset_timer = 100
	elif (is_in_group("obj_pepgoblin")):
		throw_frame = 1
		throw_sprite = "kick"
		reset_timer = 100
	elif (is_in_group("obj_swedishmonkey")):
		throw_frame = 15
		throw_sprite = "eat"
		reset_timer = 200
	velocity.x = 0
	if ($Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1 && $Sprite.animation == throw_sprite):
		state = global.states.walk
	if (bombreset == 0 && $Sprite.frame == throw_frame):
		bombreset = reset_timer
		$Sprite.animation = throw_sprite
		if ($ScreenVisibility.is_on_screen()):
			utils.playsound("EnemyProjectile")
		if (is_in_group("obj_pizzagoblin")):
			var bombid = utils.instance_create_level(position.x, position.y, "res://Objects/Level/obj_pizzagoblinbomb.tscn")
			bombid.velocity.x = (xscale * 10)
			bombid.velocity.y = -8
		elif (is_in_group("obj_cheeserobot")):
			var blobid = utils.instance_create_level(position.x, position.y, "res://Objects/BaddieObjects/obj_cheeseblob.tscn")
			blobid.sprite_index = "goop"
			blobid.scale.x = xscale
			blobid.velocity.x = (xscale * 8)
			blobid.velocity.y = 0
			blobid.grav = 0
		elif (is_in_group("obj_spitcheese")):
			var blobid = utils.instance_create_level(position.x + (xscale * 6), position.y - 6, "res://Objects/BaddieObjects/obj_spitcheesespike.tscn")
			blobid.velocity.x = (xscale * 5)
			blobid.velocity.y = -6
		elif (is_in_group("obj_trash") || is_in_group("obj_invtrash")):
			var blobid = utils.instance_create_level(position.x + (xscale * 6), position.y - 6, "res://Objects/BaddieObjects/obj_cheeseball.tscn")
			blobid.scale.x = xscale
			blobid.velocity.x = (xscale * 5)
			blobid.velocity.y = -4
		elif (is_in_group("obj_robot")):
			var blobid = utils.instance_create_level(position.x, position.y, "res://Objects/BaddieObjects/obj_robotknife.tscn")
			blobid.scale.x = xscale
			blobid.velocity.x = (xscale * 5)
		elif (is_in_group("obj_kentukykenny")):
			var blobid = utils.instance_create_level(position.x, position.y, "res://Objects/BaddieObjects/obj_kentukykenny_projectile.tscn")
			blobid.scale.x = xscale
		elif (is_in_group("obj_pizzard")):
			var blobid = utils.instance_create_level(position.x, position.y, "res://Objects/BaddieObjects/obj_pizzard_bolt.tscn")
			blobid.scale.x = xscale
		elif (is_in_group("obj_swedishmonkey")):
			var blobid = utils.instance_create_level(position.x, position.y, "res://Objects/Level/obj_slipnslide.tscn")
			blobid.baddieid = name
			blobid.scale.x = xscale
			blobid.velocity.x = ((-xscale) * 4)
			blobid.velocity.y = -4
			for i in get_tree().get_nodes_in_group("obj_slipnslide"):
				if (i.baddieid == name):
					i.banana += 1
		elif (is_in_group("obj_pepgoblin")):
			var blobid = utils.instance_create_level(position.x, position.y, "res://Objects/Hitboxes/obj_pepgoblin_kickhitbox.tscn")
			blobid.scale.x = xscale
			blobid.baddieid = name
	if (!is_on_floor() && velocity.x < 0):
		velocity.x += 0.1
	elif (!is_on_floor() && velocity.x > 0):
		velocity.x -= 0.1

func scr_enemy_chase():
	var obj_player = utils.get_player()
	if (position.x != obj_player.position.x && (!(xscale == -(sign((position.x - obj_player.position.x)))))):
		movespeed = 7
		xscale = (-(sign((position.x - obj_player.position.x))))
		momentum = ((-xscale) * (movespeed + 4))
	velocity.x = ((xscale * movespeed) + momentum)
	if (momentum > 0):
		momentum -= 0.1
	if (momentum <= 0):
		momentum += 0.1
		
func scr_enemy_rage():
	if (is_in_group("obj_cheeseslime")):
		if ($Sprite.frame > 10):
			velocity.x = (xscale * 8)
			var hitboxid = utils.instance_create(-50000, -50000, "res://Objects/Hitboxes/obj_baddieragehitbox.tscn")
			hitboxid.baddieid = name
		else:
			velocity.x = 0
		if ($Sprite.frame == $Sprite.frames.get_frame_count($Sprite.animation) - 1):
			state = global.states.walk
			$Sprite.animation = spr_walk

func scr_scareenemy():
	var player = utils.get_player()
	if (player.position.x > (position.x - 400) && player.position.x < (position.x + 400) && position.y <= (player.position.y + 60) && position.y >= (player.position.y - 60)):
		if (state != global.states.idle && player.state == global.states.mach3):
			state = global.states.idle
			$Sprite.animation = spr_scared
			if (position.x != player.position.x):
				xscale = (-(sign(position.x - player.position.x)))

func _on_AfterImageTimer_timeout():
	var afterimage = utils.instance_create_level(position.x, position.y, "res://Objects/Visuals/obj_afterimage.tscn")
	afterimage.sprite = $Sprite.frames.get_frame($Sprite.animation, $Sprite.frame)
	afterimage.scale.x = scale.x
	if (state == global.states.rage):
		$AfterImageTimer.start()
