class_name obj_player
extends KinematicBody2D

const FLOOR_NORMAL = Vector2.UP
var grav = 0.5
var velocity = Vector2.ZERO

var xscale = 1
var yscale = 1
var dir = xscale
var movespeed = 19
var wallspeed = 0

var targetLevel = ""
var targetRoom = ""

var sprite_index

var facehurt = 1
var steppy = 0
var jumpstop = 0
var mach2 = 0
var landAnim = 0
var jumpAnim = 1
var machslideAnim = 0
var machhitAnim = 0
var machpunchAnim = 0
var moveAnim = 1
var shotgunAnim = 0
var windingAnim = 0
var stompAnim = 0
var stopAnim = 1
var crouchslideAnim = 1
var crouchAnim = 1
var facestompAnim = 0
var idle = 0
var idleanim = 0
var suplexmove = 0
var heavy = false
var lastmove = 0
var tauntstoredstate = global.states.normal
var tauntstoredmovespeed = 6
var tauntstoredsprite = "idle"
var taunttimer = 20
var fallinganimation = 0
var momemtum = 0
var superslam = 0
var swingdingbuffer = 0
var punch = 0
var anger = 0
var angry = 0
var input_buffer_jump = 8
var input_buffer_secondjump = 8
var input_buffer_highjump = 8
var ladderbuffer = 0
var freefallsmash = 0
var freefallstart = 0
var bounce = 0
var character = "P"
var crouchmask = false
var instakillmove = 0
var grabbing = 0
var toomuchalarm1 = 0
var toomuchalarm2 = 0
var bombpeptimer = 100
var baddiegrabbed = ""
var attacking = 0
var inv_frames = 0
var hurted = 0
var cutscene = false
var indoor = false
var backtohubstartx = position.x
var backtohubstarty = position.y
var backtohubroom = "Realtitlescreen"
var lastroom = ""
var lastroom_x = 0
var lastroom_y = 0
onready var hurttimer = $HurtTimer
onready var hurttimer2 = $HurtTimer2
onready var pepsprite = $PeppinoSprite
onready var slopecheck = $SlopeCheck

var state = global.states.titlescreen

func _ready():
	var SaveManager = ConfigFile.new()
	var SaveData = SaveManager.load("user://saveData.ini")
	global.option_fullscreen = SaveManager.get_value("Option", "fullscreen", false)
	global.option_resolution = SaveManager.get_value("Option", "resolution", 1)
	if (global.option_fullscreen):
		OS.window_fullscreen = true
	else:
		OS.window_fullscreen = false
	if (global.option_resolution == 0):
		OS.window_size = Vector2(480, 270)
	if (global.option_resolution == 1):
		OS.window_size = Vector2(960, 540)
	if (global.option_resolution == 2):
		OS.window_size = Vector2(1920, 1080)

func _process(delta):
	$PeppinoSprite.playing = true
	sprite_index = $PeppinoSprite.animation
	position.x += velocity.x
	position.y += velocity.y
	if xscale == 1:
		$PeppinoSprite.flip_h = false
		$SolidCheck.scale.x = 1
		$SolidCheck2.scale.x = 1
		$ObjectCheck.scale.x = 1
		$WallClimbCheck.scale.x = 1
	elif xscale == -1:
		$PeppinoSprite.flip_h = true
		$SolidCheck.scale.x = -1
		$SolidCheck2.scale.x = -1
		$ObjectCheck.scale.x = -1
		$WallClimbCheck.scale.x = -1
	if ($PeppinoSprite.animation == "finishingblow1" || $PeppinoSprite.animation == "finishingblow2" || $PeppinoSprite.animation == "finishingblow3" || $PeppinoSprite.animation == "finishingblow4" || $PeppinoSprite.animation == "finishingblow5" || $PeppinoSprite.animation == "uppercutfinishingblow"):
		if (!$PeppinoSprite.flip_h):
			$PeppinoSprite.position.x = -20
		elif ($PeppinoSprite.flip_h):
			$PeppinoSprite.position.x = -80
	else:
		$PeppinoSprite.position.x = 0
	if crouchmask:
		$CrouchCollision.set_deferred("disabled", false)
		$PlayerCollision.set_deferred("disabled", true)
		$CrouchCheck.enabled = true
	else:
		$CrouchCollision.set_deferred("disabled", true)
		$PlayerCollision.set_deferred("disabled", false)
		$CrouchCheck.enabled = false
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider != null:
			if collision.collider.is_in_group("obj_hungrypillar"):
				if (state == global.states.handstandjump):
					state = global.states.finishingblow
					var rng = utils.randi_range(1, 5)
					if (rng == 1):
						$PeppinoSprite.animation = "finishingblow1"
					elif (rng == 2):
						$PeppinoSprite.animation = "finishingblow2"
					elif (rng == 3):
						$PeppinoSprite.animation = "finishingblow3"
					elif (rng == 4):
						$PeppinoSprite.animation = "finishingblow4"
					elif (rng == 5):
						$PeppinoSprite.animation = "finishingblow5"
					velocity.x = 0
					movespeed = 0
				if (instakillmove == 1):
					collision.collider.destroy()
			if collision.collider.is_in_group("obj_spike"):
				if (state == global.states.bombpep && hurted == 0):
					$Bombpep2.play()
					hurted = 1
					velocity.y = -4
					$PeppinoSprite.animation = "bombpepend"
					state = global.states.bombpep
					bombpeptimer = 0
			if collision.collider.is_in_group("obj_destructibles"):
				if (state == global.states.mach2 || state == global.states.mach3 || state == global.states.machroll || state == global.states.knightpepslopes || state == global.states.tumble):
					collision.collider.destroy()
					if (state == global.states.mach2):
						machpunchAnim = 1
				if ((state == global.states.knightpep || state == global.states.superslam) && velocity.y > 0):
					collision.collider.destroy()
				if (velocity.y <= 0.5 && (state == global.states.jump || state == global.states.climbwall || state == global.states.fireass || state == global.states.Sjump || state == global.states.mach2 || state == global.states.mach3)):
					if $JumpCheck.is_colliding():
						collision.collider.destroy()
						if (state != global.states.Sjump && state != global.states.climbwall):
							velocity.y = 0
				if (velocity.y >= 0 && (state == global.states.freefall || state == global.states.freefallland)):
					if ($FallCheck.is_colliding()):
						if ($FallCheck.get_collider().is_in_group("obj_bigdestructibles")):
							if (!shotgunAnim):
								$PeppinoSprite.animation = "bodyslamland"
							else:
								$PeppinoSprite.animation = "shotgunjump2"
							state = global.states.freefallland
						collision.collider.destroy()
				if (state == global.states.freefall || state == global.states.freefallland):
					if ($FallCheck.is_colliding() && $FallCheck.get_collider().is_in_group("obj_metalblock") && freefallsmash > 10):
						collision.collider.destroy()
				if (state == global.states.handstandjump):
					if ($SolidCheck.is_colliding() && $SolidCheck.get_collider().is_in_group("obj_bigdestructibles")):
						if (!shotgunAnim):
							$PeppinoSprite.animation = "tackle"
							state = global.states.tackle
							movespeed = 3
							velocity.y = -3
							collision.collider.destroy()
						else:
							state = global.states.shotgun
							$PeppinoSprite.animation = "shotgun"
							var bullet = utils.instance_create(position.x + 70, position.y + 70, "res://Objects/Visuals/obj_spikehurteffect.tscn")
							bullet.spdh = 4
							collision.collider.destroy()
					if (!collision.collider.is_in_group("obj_bigdestructibles")):
						collision.collider.destroy()
			if collision.collider.is_in_group("obj_hurtbox"):
				if ((state == global.states.knightpep || state == global.states.knightpepattack || state == global.states.knightpepslopes) && !cutscene):
					pass
				elif (state == global.states.bombpep && hurted == 0):
					pass
				elif (state == global.states.tumble):
					pass
				elif (state == global.states.cheesepep || state == global.states.cheesepepstick):
					pass
				elif (state != global.states.hurt && hurted == 0 && state != global.states.bump && !cutscene):
					if collision.collider.is_in_group("obj_forkhitbox"):
						position.x += (8 * (-xscale))
					utils.playsound("PepHurt")
					$HurtTimer.wait_time = 1
					$HurtTimer.start()
					$HurtTimer2.wait_time = 2
					$HurtTimer2.start()
					hurted = 1
					if (xscale == collision.collider.scale.x):
						$PeppinoSprite.animation = "hurtjump"
					else:
						$PeppinoSprite.animation = "hurt"
					movespeed = 8
					velocity.y = -5
					utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_spikehurteffect.tscn")
					state = global.states.hurt
					if (shotgunAnim == 0 && character == "P"):
						global.hurtcounter += 1
						if (global.collect > 100):
							global.collect -= 100
						else:
							global.collect = 0
						if (global.collect != 0):
							utils.instance_create(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
							utils.instance_create(position.x + 50, position.y + 50, "res://Objects/Visuals/obj_pizzaloss.tscn")
					elif (character == "P"):
						$PeppinoSprite.animation = "shotgunback"
						shotgunAnim = 0
			if collision.collider.is_in_group("obj_baddie"):
				var baddie = collision.collider
				if (baddie.state != global.states.grabbed && !cutscene):
					if (instakillmove == 1):
						if (state == global.states.mach3 && $PeppinoSprite.animation != "mach3hit"):
							$PeppinoSprite.animation = "mach3hit"
						if (state == global.states.mach2 && is_on_floor()):
							machpunchAnim = 1
						utils.playsound("Punch")
						global.hit += 1
						global.combotime = 60
						if (!is_on_floor() && state != global.states.freefall && Input.is_action_just_pressed("key_jump")):
							if (state == global.states.mach3 || state == global.states.mach2):
								$PeppinoSprite.animation = "mach2jump"
							suplexmove = 0
							velocity.y = -11
						baddie.destroy()
					if (global_position.y < baddie.global_position.y && attacking == 0 && $PeppinoSprite.animation != "mach2jump" && (state == global.states.jump || state == global.states.mach1 || state == global.states.grab) && velocity.y >= 0 && baddie.velocity.y >= 0 && $PeppinoSprite.animation != "stompprep"):
						utils.playsound("Stomp")
						baddie.state = global.states.stun
						if (baddie.stunned < 100):
							baddie.stunned = 100
						if Input.is_action_just_pressed("key_jump"):
							utils.instance_create(global_position.x, (global_position.y + 50), "res://Objects/Visuals/obj_stompeffect.tscn")
							stompAnim = 1
							velocity.y = -14
							if (state != global.states.grab):
								$PeppinoSprite.animation = "stompprep"
						else:
							utils.instance_create(global_position.x, (global_position.y + 50), "res://Objects/Visuals/obj_stompeffect.tscn")
							stompAnim = 1
							velocity.y = -9
							if (state != global.states.grab):
								$PeppinoSprite.animation = "stompprep"
					if (baddie.state != global.states.pizzagoblinthrow && baddie.velocity.y >= 0 && state != global.states.tackle && state != global.states.superslam && state != global.states.machslide && state != global.states.freefall && state != global.states.mach2 && state != global.states.handstandjump && state != global.states.mach3 && state != global.states.machroll):
						utils.playsound("Bump")
						if (state != global.states.bombpep && state != global.states.mach1):
							movespeed = 0
						if (baddie.is_in_group("obj_pizzaball")):
							global.golfhit += 1
						if (baddie.stunned < 100):
							baddie.stunned = 100
						baddie.velocity.y = -5
						baddie.velocity.x = ((-xscale) * 2)
						baddie.state = global.states.stun
					if (state == global.states.superslam || state == global.states.freefall):
						utils.playsound("HitEnemy")
						global.combotime = 60
						utils.instance_create(baddie.global_position.x, baddie.global_position.y, "res://Objects/Baddies/obj_baddiegibs.tscn")
						baddie.state = global.states.stun
						baddie.hp -= 1
						if (baddie.stunned < 100):
							baddie.stunned = 100
						utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
						utils.instance_create(baddie.global_position.x, baddie.global_position.y, "res://Objects/Visuals/obj_bangeffect.tscn")
						if (baddie.hp <= 0):
							baddie.stunned = 200
							baddie.state = global.states.stun
						velocity.y = -7
						state = global.states.normal
						baddie.velocity.y = -4
						baddie.velocity.x = (xscale * 5)
					if (state == global.states.handstandjump && character == "P"):
						if (shotgunAnim == 0):
							movespeed = 0
							$PeppinoSprite.animation = "haulingstart"
							state = global.states.grab
							baddie.state = global.states.grabbed
						else:
							pass
							# insert code for shotgun
	match state:
		global.states.normal:
			scr_player_normal()
		global.states.jump:
			scr_player_jump()
		global.states.backbreaker:
			scr_player_backbreaker()
		global.states.crouch:
			scr_player_crouch()
		global.states.crouchjump:
			scr_player_crouchjump()
		global.states.crouchslide:
			scr_player_crouchslide()
		global.states.freefallprep:
			scr_player_freefallprep()
		global.states.freefall:
			scr_player_freefall()
		global.states.freefallland:
			scr_player_freefallland()
		global.states.bump:
			scr_player_bump()
		global.states.comingoutdoor:
			scr_player_comingoutdoor()
		global.states.door:
			scr_player_door()
		global.states.handstandjump:
			scr_player_handstandjump()
		global.states.hurt:
			scr_player_hurt()
		global.states.mach1:
			scr_player_mach1()
		global.states.mach2:
			scr_player_mach2()
		global.states.mach3:
			scr_player_mach3()
		global.states.machfreefall:
			scr_player_machfreefall()
		global.states.machslide:
			scr_player_machslide()
		global.states.machroll:
			scr_player_machroll()
		global.states.tumble:
			scr_player_tumble()
		global.states.climbwall:
			scr_player_climbwall()
		global.states.titlescreen:
			scr_player_titlescreen()
		global.states.Sjump:
			scr_player_Sjump()
		global.states.Sjumpland:
			scr_player_Sjumpland()
		global.states.Sjumpprep:
			scr_player_Sjumpprep()
		global.states.fireass:
			scr_player_fireass()
		global.states.timesup:
			scr_player_timesup()
		global.states.gameover:
			scr_player_gameover()
		global.states.victory:
			scr_player_victory()
		global.states.grab:
			scr_player_grab()
		global.states.superslam:
			scr_player_superslam()
		global.states.finishingblow:
			scr_player_finishingblow()
		global.states.ladder:
			scr_player_ladder()
		global.states.tackle:
			scr_player_tackle()
	scr_playersounds()
	if (is_on_floor() && state != global.states.handstandjump):
		suplexmove = 0
	if (state != global.states.freefall):
		freefallsmash = 0
	#if (!utils.instance_exists_level(baddiegrabbed) && (state == global.states.grab || state == global.states.superslam)):
		#state = global.states.normal
	if (!(state == global.states.grab || state == global.states.superslam || state == global.states.mach2)):
		baddiegrabbed = ""
	if (character == "P"):
		if (anger == 0):
			angry = 0
		if (anger > 0):
			angry = 1
			anger -= 1
	if ($PeppinoSprite.animation == "winding" && state != global.states.normal):
		windingAnim = 0
	if (global.combotime > 0):
		global.combotime -= 0.5
	if (global.combotime == 0 && global.combo != 0):
		global.combo = 0
	if (input_buffer_jump < 8):
		input_buffer_jump += 1
	if (input_buffer_secondjump < 8):
		input_buffer_secondjump += 1
	if (input_buffer_highjump < 8):
		input_buffer_highjump += 1
	if (inv_frames == 0 && hurted == 0):
		modulate.a = 1
	if (state == global.states.mach2 || state == global.states.knightpep || state == global.states.knightpepslopes || state == global.states.knightpepattack || state == global.states.facestomp || state == global.states.cheesepep || state == global.states.bombpep || state == global.states.machfreefall || state == global.states.machroll || state == global.states.mach3 || state == global.states.freefall || state == global.states.Sjump):
		attacking = 1
	else:
		attacking = 0
	if (state == global.states.throw || state == global.states.punch || state == global.states.backkick || state == global.states.shoulder || state == global.states.uppunch):
		grabbing = 1
	else:
		grabbing = 0
	if (state == global.states.mach3 || state == global.states.mach2 || state == global.states.climbwall || state == global.states.freefall || state == global.states.tumble || state == global.states.fireass || state == global.states.Sjump || state == global.states.machroll || state == global.states.machfreefall || (state == global.states.superslam && $PeppinoSprite.animation == "piledriver") || state == global.states.knightpep || state == global.states.knightpepattack || state == global.states.knightpepslopes):
		instakillmove = 1
	else:
		instakillmove = 0
	if ((state != global.states.jump && state != global.states.crouchjump) || velocity.y < 0):
		fallinganimation = 0
	if state != global.states.normal:
		facehurt = 0
	if state != global.states.normal:
		machslideAnim = 0
	if state != global.states.normal && state != global.states.jump && state != global.states.mach1 && state != global.states.mach2 && state != global.states.mach3 && state != global.states.handstandjump && state != global.states.freefallprep:
		momemtum = 0
	if state != global.states.normal:
		idle = 0
	if (state != global.states.facestomp):
		facestompAnim = 0
	if (state != global.states.freefall && state != global.states.facestomp && state != global.states.superslam && state != global.states.freefallland):
		superslam = 0
	if state != global.states.mach2:
		machpunchAnim = 0
	if state != global.states.jump:
		ladderbuffer = 0
	if state != global.states.jump:
		stompAnim = 0
	if ((state == global.states.mach3 || state == global.states.mach2 || state == global.states.climbwall || state == global.states.machroll || state == global.states.handstandjump || state == global.states.machslide) && (!utils.instance_exists("obj_mach3effect"))):
		toomuchalarm1 = 6
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_mach3effect.tscn")
	if (toomuchalarm1 > 0):
		toomuchalarm1 -= 1
		if (toomuchalarm1 <= 0 && (state == global.states.mach3 || state == global.states.mach2 || state == global.states.climbwall || state == global.states.machroll || state == global.states.handstandjump || state == global.states.machslide)):
			utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_mach3effect.tscn")
			toomuchalarm1 = 6
	if (!$CrouchCheck.is_colliding()):
		if (state != global.states.bump && state != global.states.tumble && state != global.states.fireass && state != global.states.crouch && state != global.states.machroll && state != global.states.hurt && state != global.states.crouchslide && state != global.states.crouchjump):
			crouchmask = false
		else:
			crouchmask = true
	else:
		crouchmask = true
	if (state == global.states.gottreasure || $PeppinoSprite.animation == "knightpep_start" || $PeppinoSprite.animation == "knightpep_thunder" || state == global.states.keyget || state == global.states.door || state == global.states.ejected || state == global.states.victory || state == global.states.comingoutdoor || state == global.states.gameover):
		cutscene = true
	else:
		cutscene = false
	if (indoor && !utils.instance_exists("obj_uparrow")):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_uparrow.tscn")
	if (state == global.states.mach2 && (!utils.instance_exists("obj_speedlines"))):
		utils.instance_create(global_position.x, global_position.y, "res://Objects/Visuals/obj_speedlines.tscn")

func _physics_process(delta):
	var snap_vector = Vector2.ZERO
	if ($SlopeCheck.is_colliding() && $SlopeCheck.get_collider().is_in_group("obj_slope") && !Input.is_action_pressed("key_jump") && (state != global.states.jump && state != global.states.climbwall)):
		snap_vector = Vector2.DOWN * 20
	if state != global.states.titlescreen:
		if state != global.states.backbreaker && state != global.states.Sjumpland && state != global.states.ladder:
			velocity.y += grav
		velocity = move_and_slide_with_snap(velocity, snap_vector, FLOOR_NORMAL, true, 4, 1)
		
func get_sprite_frame():
	return $PeppinoSprite.frames.get_frame($PeppinoSprite.animation, $PeppinoSprite.frame)
	
func get_frame():
	return $PeppinoSprite.frame
	
func set_animation(anim: String):
	$PeppinoSprite.animation = anim
	
func place_meeting(collisionpos: Vector2, object: String):
	var collisiondata = move_and_collide(collisionpos, true, true, true)
	if collisiondata != null:
		if collisiondata.collider != null:
			if collisiondata.collider.is_in_group(object):
				return true
			else:
				return false
		else:
			return false
			
func is_colliding_with_wall():
	if (state == global.states.mach1 || state == global.states.normal || state == global.states.machslide):
		if ((($SolidCheck.is_colliding() && ($SolidCheck.get_collider().is_in_group("obj_solid") || $SolidCheck.get_collider().is_in_group("obj_destructibles"))) || ($SolidCheck2.is_colliding() && $SolidCheck2.get_collider().is_in_group("obj_solid"))) && !utils.instance_exists("obj_fadeout")):
			return true
		else:
			return false
	else:
		if ((($SolidCheck.is_colliding() && $SolidCheck.get_collider().is_in_group("obj_solid")) || ($SolidCheck2.is_colliding() && $SolidCheck2.get_collider().is_in_group("obj_solid"))) && !utils.instance_exists("obj_fadeout")):
			return true
		else:
			return false
		
func is_wallclimbable():
	if ((($SolidCheck.is_colliding() && $SolidCheck.get_collider().is_in_group("obj_solid")) || ($WallClimbCheck.is_colliding() && $WallClimbCheck.get_collider().is_in_group("obj_solid")))):
		return true
	else:
		return false
		
func is_collding_wallclimb():
	if ($SolidCheck.is_colliding() || $WallClimbCheck.is_colliding()):
		return true
	else:
		return false
		
func is_colliding():
	if ($SolidCheck.is_colliding() || $SolidCheck2.is_colliding()):
		return true
	else:
		return false
	
func scr_dotaunt():
	if Input.is_action_just_pressed("key_taunt"):
		$Taunt.play()
		taunttimer = 20
		tauntstoredmovespeed = movespeed
		tauntstoredsprite = $PeppinoSprite.animation
		tauntstoredstate = state
		state = global.states.backbreaker
		$PeppinoSprite.animation = "taunt"
		$PeppinoSprite.frame = utils.randi_range(0, $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1)
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_taunteffect.tscn")
	
func scr_player_normal():
	if (dir != xscale):
		dir = xscale
		movespeed = 2
		facehurt = 0
	mach2 = 0
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	velocity.x = (move * movespeed)
	if (!machslideAnim && !landAnim && !shotgunAnim):
		if (move == 0):
			if (idle < 400):
				idle += 1
			if (idle >= 150 && $PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
				facehurt = 0
				idle = 0
			if (idle >= 150 && $PeppinoSprite.animation != "idledance" && $PeppinoSprite.animation != "idlefrown" && $PeppinoSprite.animation != "handgesture1" && $PeppinoSprite.animation != "handgesture2" && $PeppinoSprite.animation != "handgesture3" && $PeppinoSprite.animation != "handgesture4"):
				randomize()
				idleanim = utils.randi_range(0, 100)
				if (idleanim <= 16):
					$PeppinoSprite.animation = "idledance"
				if (idleanim > 16 && idleanim < 32):
					$PeppinoSprite.animation = "idlefrown"
				if (idleanim > 32 && idleanim < 48):
					$PeppinoSprite.animation = "handgesture1"
				if (idleanim > 48 && idleanim < 64):
					$PeppinoSprite.animation = "handgesture2"
				if (idleanim > 64 && idleanim < 80):
					$PeppinoSprite.animation = "handgesture3"
				if (idleanim > 80):
					$PeppinoSprite.animation = "handgesture4"
			if (idle < 150):
				if (facehurt == 0):
					if (windingAnim < 1800 || angry == 1):
						movespeed = 0
						if (global.minutes == 0 && global.seconds == 0):
							$PeppinoSprite.animation = "hurtidle"
						elif (global.panic):
							$PeppinoSprite.animation = "panic"
						elif (angry):
							$PeppinoSprite.animation = "3hpidle"
						else:
							$PeppinoSprite.animation = "idle"
					elif (character == "P"):
						idle = 0
						windingAnim -= 1
						$PeppinoSprite.animation = "winding"
				elif (facehurt == 1 && character == "P"):
					windingAnim = 0
					if ($PeppinoSprite.animation != "facehurtup" && $PeppinoSprite.animation != "facehurt"):
						$PeppinoSprite.animation = "facehurtup"
					if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && $PeppinoSprite.animation == "facehurtup"):
						$PeppinoSprite.animation = "facehurt"
		if (move != 0):
			machslideAnim = 0
			idle = 0
			facehurt = 0
			if (global.minutes == 0 && global.seconds == 0):
				$PeppinoSprite.animation = "hurtwalk"
			elif (angry):
				$PeppinoSprite.animation = "3hpwalk"
			else:
				$PeppinoSprite.animation = "move"
		if (move != 0):
			xscale = move
	if (landAnim == 1):
		if (shotgunAnim == 0):
			if (move == 0):
				movespeed = 0
				$PeppinoSprite.animation = "land"
				if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
					landAnim = 0
			if (move != 0):
				$PeppinoSprite.animation = "land2"
				if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
					landAnim = 0
					$PeppinoSprite.animation = "move"
		if (shotgunAnim == 1):
			$PeppinoSprite.animation = "shotgun_land"
			if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
				landAnim = 0
				$PeppinoSprite.animation = "move"
	if (machslideAnim == 1):
		$PeppinoSprite.animation = "machslideend"
		if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && $PeppinoSprite.animation == "machslideend"):
			machslideAnim = 0
	if ($PeppinoSprite.animation == "shotgun" && $PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		$PeppinoSprite.animation = "shotgun_idle"
	if (landAnim == 0):
		if (shotgunAnim == 1 && move == 0 && $PeppinoSprite.animation != "shotgun"):
			$PeppinoSprite.animation = "shotgun_idle"
		elif (shotgunAnim == 1 && $PeppinoSprite.animation != "shotgun"):
			$PeppinoSprite.animation = "shotgun_walk"
	if (is_on_wall() && xscale == 1 && move == 1):
		movespeed = 0
	if (is_on_wall() && xscale == -1 && move == -1):
		movespeed = 0
	jumpstop = 0
	if (!is_on_floor() && !Input.is_action_just_pressed("key_jump")):
		if (shotgunAnim == 0):
			$PeppinoSprite.animation = "fall"
		else:
			$PeppinoSprite.animation = "shotgun_fall"
		jumpAnim = 0
		state = global.states.jump
	if (Input.is_action_just_pressed("key_jump") && is_on_floor() && !Input.is_action_pressed("key_down")):
		$Jump.play()
		$PeppinoSprite.animation = "jump"
		if (shotgunAnim == 1):
			$PeppinoSprite.animation = "shotgun_jump"
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_highjumpcloud2.tscn")
		for i in get_tree().get_nodes_in_group("obj_highjumpcloud2"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
		velocity.y = -11
		state = global.states.jump
		jumpAnim = 1
	if (is_on_floor() && input_buffer_jump < 8 && !Input.is_action_pressed("key_down") && !Input.is_action_pressed("key_dash") && velocity.y >= 0):
		$Jump.play()
		$PeppinoSprite.animation = "jump"
		if (shotgunAnim == 1):
			$PeppinoSprite.animation = "shotgun_jump"
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_highjumpcloud2.tscn")
		for i in get_tree().get_nodes_in_group("obj_highjumpcloud2"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
		stompAnim = 0
		velocity.y = -11
		state = global.states.jump
		jumpAnim = 1
		jumpstop = 0
	if ((Input.is_action_pressed("key_down") && is_on_floor()) || ($CrouchCheck.is_colliding() && is_on_floor()) && character == "P"):
		state = global.states.crouch
		landAnim = 0
		crouchAnim = 1
		idle = 0
	if (move != 0):
		if movespeed < 6:
			movespeed += 0.5
		elif (floor(movespeed) == 6):
			movespeed = 6
	else:
		movespeed = 0
	if (movespeed > 6):
		movespeed -= 0.1
	momemtum = 0
	if (move != 0):
		xscale = move
		if (movespeed < 3 && move != 0):
			$PeppinoSprite.speed_scale = 0.35
		elif (movespeed > 3 && movespeed < 6):
			$PeppinoSprite.speed_scale = 0.45
		else:
			$PeppinoSprite.speed_scale = 0.6
	else:
		$PeppinoSprite.speed_scale = 0.35
	if (Input.is_action_just_pressed("key_grab") && character == "P" && (!(shotgunAnim == 1 && Input.is_action_pressed("key_up")))):
		suplexmove = 1
		$SuplexDash.play()
		state = global.states.handstandjump
		if (shotgunAnim == 0):
			$PeppinoSprite.animation = "suplexdash"
		else:
			$PeppinoSprite.animation = "shotgun_suplexdash"
		movespeed = 6
	if (Input.is_action_pressed("key_dash") && !is_on_wall() && !is_colliding_with_wall()):
		movespeed = 6
		$PeppinoSprite.animation = "mach1"
		jumpAnim = 1
		state = global.states.mach1
	if (move != 0 && ($PeppinoSprite.frame == 3 || $PeppinoSprite.frame == 8) && steppy == 0):
		utils.instance_create(position.x, (position.y + 43), "res://Objects/Visuals/obj_cloudeffect.tscn")
		steppy = 1
	if (move != 0 && $PeppinoSprite.frame != 3 && $PeppinoSprite.frame != 8):
		steppy = 0
	scr_dotaunt()
		
func scr_player_jump():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (momemtum == 0):
		velocity.x = (move * movespeed)
	else:
		velocity.x = (xscale * movespeed)
	if (dir != xscale):
		dir = xscale
		movespeed = 2
		facehurt = 0
	if (move != xscale):
		movespeed = 2
	if (movespeed == 0):
		momemtum = 0
	if (move != 0 && movespeed < 6):
		movespeed += 0.5
	if (movespeed > 6):
		movespeed -= 0.1
	if (is_on_wall() && move != 0 && movespeed < 2):
		movespeed = 0
	if (dir != xscale):
		dir = xscale
	landAnim = 1
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5 && stompAnim == 0):
		velocity.y /= 10
		jumpstop = 1
	if (ladderbuffer > 0):
		ladderbuffer -= 1
	if (is_on_ceiling() && jumpstop == 0 && jumpAnim == 1):
		velocity.y = grav
		jumpstop = 1
	if (is_on_floor() && input_buffer_jump < 8 && !Input.is_action_pressed("key_down") && !Input.is_action_pressed("key_dash") && velocity.y >= 0 && (!(($PeppinoSprite.animation == "facestomp" || $PeppinoSprite.animation == "freefall")))):
		$Jump.play()
		$PeppinoSprite.animation = "jump"
		if (shotgunAnim == 1):
			$PeppinoSprite.animation = "shotgun_jump"
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_highjumpcloud2.tscn")
		stompAnim = 0
		velocity.y = -11
		state = global.states.jump
		jumpAnim = 1
		jumpstop = 0
		movespeed = 2
	if ((is_on_floor() && velocity.y >= 0 && !Input.is_action_pressed("key_dash"))):
		$Step.play()
		if Input.is_action_pressed("key_dash"):
			landAnim = 0
		input_buffer_secondjump = 0
		state = global.states.normal
		jumpAnim = 1
		jumpstop = 0
		movespeed = 2
	if Input.is_action_just_pressed("key_jump"):
		input_buffer_jump = 0
	if (character == "P"):
		if (velocity.y > 5):
			fallinganimation += 1
		if (fallinganimation >= 40 && fallinganimation < 80):
			$PeppinoSprite.animation = "facestomp"
		if (fallinganimation >= 80):
			$PeppinoSprite.animation = "freefall"
	if (stompAnim == 0):
		if (jumpAnim == 1):
			if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
				jumpAnim = 0
		if (jumpAnim == 0):
			if ($PeppinoSprite.animation == "airdash1"):
				$PeppinoSprite.animation = "airdash2"
			if ($PeppinoSprite.animation == "shotgun_jump"):
				$PeppinoSprite.animation = "shotgun_fall"
			if ($PeppinoSprite.animation == "jump"):
				$PeppinoSprite.animation = "fall"
			if ($PeppinoSprite.animation == "shotgunjump1"):
				$PeppinoSprite.animation = "shotgunjump2"
	if (stompAnim == 1):
		if ($PeppinoSprite.animation == "stompprep" && $PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
			$PeppinoSprite.animation = "stomp"
	if (Input.is_action_pressed("key_down")):
		if (shotgunAnim == 0):
			state = global.states.freefallprep
			$PeppinoSprite.animation = "bodyslamstart"
			velocity.y = -5
		#else:
			#TODO: Implement shotgun bodyslam
	if (move != 0):
		xscale = move
	$PeppinoSprite.speed_scale = 0.35
	if (is_on_floor() && ($PeppinoSprite.animation == "facestomp" || $PeppinoSprite.animation == "freefall")):
		for i in utils.get_tree().get_nodes_in_group("obj_baddie"):
			if (i.is_on_floor() && i.screenvisible):
				i.velocity.y = -7
				i.velocity.x = 0
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 10
			i.shake_mag_acc = (30 / 30)
		$Groundpound.play()
		$PeppinoSprite.animation = "bodyslamland"
		state = global.states.freefallland
	if (Input.is_action_just_pressed("key_grab") && character == "P" && suplexmove == 0 && (!(shotgunAnim == 1 && Input.is_action_pressed("key_up")))):
		suplexmove = 1
		$SuplexDash.play()
		state = global.states.handstandjump
		$PeppinoSprite.animation = "suplexdashjumpstart"
		velocity.y = -4
		movespeed = 6
	if (!Input.is_action_pressed("key_dash") && move != xscale):
		mach2 = 0
	if (Input.is_action_pressed("key_dash") && is_on_floor() && fallinganimation < 40):
		movespeed = 6
		$PeppinoSprite.animation = "mach1"
		jumpAnim = 1
		state = global.states.mach1
	scr_dotaunt()
	
func scr_player_backbreaker():
	mach2 = 0
	if ($PeppinoSprite.animation != "machfreefall"):
		velocity.x = 0
		movespeed = 0
	else:
		velocity.x = (xscale * movespeed)
	landAnim = 0
	if ($PeppinoSprite.animation == "machfreefall"):
		state = global.states.machslide
		$PeppinoSprite.animation = "crouchslide"
	if ($PeppinoSprite.animation == "taunt"):
		taunttimer -= 1
		$PeppinoSprite.speed_scale = 0
		velocity.y = 0
	if (taunttimer == 0 && $PeppinoSprite.animation == "taunt"):
		movespeed = tauntstoredmovespeed
		$PeppinoSprite.animation = tauntstoredsprite
		state = tauntstoredstate
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && $PeppinoSprite.animation == "eatspaghetti"):
		state = global.states.normal
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && $PeppinoSprite.animation == "timesup"):
		state = global.states.normal
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && $PeppinoSprite.animation == "levelcomplete"):
		state = global.states.normal
	if ($PeppinoSprite.animation != "taunt"):
		$PeppinoSprite.speed_scale = 0.35
		
func scr_player_crouch():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	velocity.x = (move * movespeed)
	movespeed = 4
	crouchmask = true
	if (!is_on_floor() && !Input.is_action_just_pressed("key_jump")):
		jumpAnim = 0
		state = global.states.crouchjump
		movespeed = 4
		crouchAnim = 1
	if (is_on_floor() && !Input.is_action_pressed("key_down") && !$CrouchCheck.is_colliding() && !Input.is_action_just_pressed("key_jump")):
		state = global.states.normal
		movespeed = 0
		crouchAnim = 1
		jumpAnim = 1
		crouchmask = false
	if (crouchAnim == 0):
		if (move == 0):
			if (shotgunAnim == 0):
				$PeppinoSprite.animation = "crouch"
			else:
				$PeppinoSprite.animation = "shotgun_duck"
		if (move != 0):
			if (shotgunAnim == 0):
				$PeppinoSprite.animation = "crawl"
			else:
				$PeppinoSprite.animation = "shotgun_crawl"
	if (crouchAnim == 1):
		if (move == 0):
			if (shotgunAnim == 0):
				$PeppinoSprite.animation = "crouchstart"
			else:
				$PeppinoSprite.animation = "shotgun_goduck"
			if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
				crouchAnim = 0
	if (move != 0):
		xscale = move
		crouchAnim = 0
	if (Input.is_action_just_pressed("key_jump") && is_on_floor() && !$CrouchCheck.is_colliding() && character == "P"):
		$Jump.play()
		velocity.y = -8
		state = global.states.crouchjump
		movespeed = 4
		crouchAnim = 1
		jumpAnim = 1
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if collision.collider.is_in_group("obj_slope") && Input.is_action_pressed("key_down"):
			movespeed = 14
			xscale = (-sign(collision.collider.scale.x))
			state = global.states.tumble
			$PeppinoSprite.animation = "tumblestart"
	$PeppinoSprite.speed_scale = 0.45
	
func scr_player_crouchjump():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	fallinganimation += 1
	if (fallinganimation >= 40 && fallinganimation < 80):
		$PeppinoSprite.animation = "facestomp"
		state = global.states.jump
	crouchmask = true
	velocity.x = (move * movespeed)
	movespeed = 4
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && jumpAnim == 1):
		velocity.y /= 2
		jumpstop = 1
	if (is_on_ceiling() && jumpstop == 0 && jumpAnim == 1):
		velocity.y = grav
		jumpstop = 1
	if (is_on_floor() && Input.is_action_pressed("key_down")):
		state = global.states.crouch
		jumpAnim = 1
		crouchAnim = 1
		jumpstop = 0
		$Step.play()
	if (jumpAnim == 1):
		if (shotgunAnim == 0):
			$PeppinoSprite.animation = "crouchjump"
		else:
			$PeppinoSprite.animation = "shotgun_crouchjump1"
		if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
			jumpAnim = 0
	if (jumpAnim == 0):
		if (shotgunAnim == 0):
			$PeppinoSprite.animation = "crouchfall"
		else:
			$PeppinoSprite.animation = "shotgun_crouchjump2"
	if (is_on_floor() && !Input.is_action_pressed("key_down") && !$CrouchCheck.is_colliding()):
		movespeed = 0
		state = global.states.normal
		jumpAnim = 1
		landAnim = 1
		crouchAnim = 1
		jumpstop = 0
		crouchmask = false
		$Step.play()
	if (move != 0):
		xscale = move
	$PeppinoSprite.speed_scale = 0.35
	
func scr_player_freefallprep():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (!is_on_floor()):
		velocity.x = (move * movespeed)
		if (move != xscale && momemtum == 1 && movespeed != 0):
			movespeed -= 0.05
		if (movespeed == 0):
			momemtum = 0
		if (move == 0 && momemtum == 0):
			movespeed = 0
			mach2 = 0
		if (move != 0 && movespeed < 7):
			movespeed += 0.25
		if (movespeed > 7):
			movespeed -= 0.05
		if (is_on_wall() && move != 0):
			movespeed = 0
		if (dir != xscale):
			mach2 = 0
			dir = xscale
			movespeed = 0
		if (move == (-xscale)):
			mach2 = 0
			movespeed = 0
			momemtum = 0
		if (move != 0):
			xscale = move
	$PeppinoSprite.speed_scale = 0.5
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		velocity.y += 14
		state = global.states.freefall
		if (shotgunAnim == 0):
			$PeppinoSprite.animation = "bodyslamfall"
		else:
			$PeppinoSprite.animation = "shotgunjump3"
	
func scr_player_freefall():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	landAnim = 1
	velocity.y = 15
	if (!is_on_floor()):
		velocity.x = (move * movespeed)
		if (move != xscale && momemtum == 1 && movespeed != 0):
			movespeed -= 0.05
		if (movespeed == 0):
			momemtum = 0
		if (move == 0 && momemtum == 0):
			movespeed = 0
			mach2 = 0
		if (move != 0 && movespeed < 7):
			movespeed += 0.25
		if (movespeed > 7):
			movespeed -= 0.05
		if (is_colliding_with_wall() && move != 0):
			movespeed = 0
		if (dir != xscale):
			mach2 = 0
			dir = xscale
			movespeed = 0
		if (move == (-xscale)):
			mach2 = 0
			movespeed = 0
			momemtum = 0
		if (move != 0):
			xscale = move
	freefallsmash += 1
	if (freefallsmash > 10 && !utils.instance_exists("obj_superslameffect")):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_superslameffect.tscn")
	if (is_on_floor() && (!(input_buffer_jump < 8))):
		$Groundpound.play()
		freefallsmash = 0
		if (shotgunAnim == 0):
			$PeppinoSprite.animation = "bodyslamland"
		else:
			$PeppinoSprite.animation = "shotgunjump2"
		state = global.states.freefallland
		jumpAnim = 1
		jumpstop = 0
		for i in get_tree().get_nodes_in_group("obj_baddie"):
			if (i.is_on_floor() && i.screenvisible):
				i.velocity.y = -11
				i.velocity.x = 0
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 20
			i.shake_mag_acc = (30 / 30)
		bounce = 0
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_landcloud.tscn")
	$PeppinoSprite.speed_scale = 0.35

func scr_player_freefallland():
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 0
	machhitAnim = 0
	movespeed = 0
	facehurt = 1
	velocity.y = 0
	velocity.x = 0
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && (!(superslam > 30))):
		state = global.states.normal
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && superslam > 30):
		state = global.states.machfreefall
		velocity.y = -7
	$PeppinoSprite.speed_scale = 0.35
	
func scr_player_bump():
	movespeed = 0
	mach2 = 0
	if (is_on_floor() && velocity.y >= 0):
		velocity.x = 0
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		state = global.states.normal
	if ($PeppinoSprite.animation != "tumbleend" && $PeppinoSprite.animation != "hitwall"):
		$PeppinoSprite.animation = "bump"
	$PeppinoSprite.speed_scale = 0.35
	
func scr_player_comingoutdoor():
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	machhitAnim = 0
	velocity.x = 0
	$PeppinoSprite.animation = "walkfront"
	$PeppinoSprite.speed_scale = 0.35
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		movespeed = 0
		state = global.states.normal
	
func scr_player_crouchslide():
	velocity.x = (xscale * movespeed)
	if (movespeed >= 0):
		movespeed -= 0.2
	crouchmask = true
	if (mach2 >= 35 && !Input.is_action_pressed("key_down") && Input.is_action_pressed("key_dash")):
		if (character == "P"):
			$PeppinoSprite.animation = "machhit"
		mach2 = 35
		state = global.states.mach2
		if (movespeed < 10):
			movespeed = 10
	if (velocity.x == 0 || movespeed <= 0):
		state = global.states.crouch
		movespeed = 0
		mach2 = 0
		crouchslideAnim = 1
		crouchAnim = 1
	if (is_on_wall()):
		movespeed = 0
		state = global.states.bump
		velocity.x = (-2.5 * xscale)
		velocity.y = -3
		mach2 = 0
		machslideAnim = 1
		machhitAnim = 0
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
	if (!utils.instance_exists("obj_slidecloud") && is_on_floor() && movespeed > 5):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_slidecloud.tscn")
		for i in get_tree().get_nodes_in_group("obj_slidecloud"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
	$PeppinoSprite.speed_scale = 0.35
	
func scr_player_door():
	velocity.x = 0
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	machhitAnim = 0
	$PeppinoSprite.speed_scale = 0.35
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		$PeppinoSprite.speed_scale = 0
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && (!utils.instance_exists("obj_fadeout")) && ($PeppinoSprite.animation == "uppizzabox" || $PeppinoSprite.animation == "downpizzabox")):
		utils.instance_create(utils.get_gamenode().global_position.x, utils.get_gamenode().global_position.y, "res://Objects/Visuals/obj_fadeout.tscn")
	
func scr_player_handstandjump():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (character == "P"):
		landAnim = 0
		velocity.x = (xscale * movespeed)
		momemtum = 1
		dir = xscale
		if (movespeed < 10 && is_on_floor()):
			movespeed += 0.5
		elif (!is_on_floor()):
			movespeed = 10
		if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5 && stompAnim == 0):
			velocity.y /= 10
			jumpstop = 1
		if (move != xscale && move != 0):
			state = global.states.normal
		if (($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 || $PeppinoSprite.animation == "suplexdashjump" || $PeppinoSprite.animation == "suplexdashjumpstart") && is_on_floor() && !Input.is_action_pressed("key_dash") && velocity.y >= 0):
			$PeppinoSprite.speed_scale = 0.35
			state = global.states.normal
		if (($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 || $PeppinoSprite.animation == "suplexdashjump" || $PeppinoSprite.animation == "suplexdashjumpstart") && is_on_floor() && Input.is_action_pressed("key_dash")):
			$PeppinoSprite.speed_scale = 0.35
			state = global.states.mach2
		if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && $PeppinoSprite.animation == "suplexdashjumpstart"):
			$PeppinoSprite.animation = "suplexdashjump"
		if (Input.is_action_pressed("key_down") && is_on_floor() && velocity.y >= 0):
			$PeppinoSprite.animation = "crouchslip"
			if (character == "P"):
				machhitAnim = 0
			state = global.states.crouchslide
			movespeed = 15
		if (!is_on_floor() && ($PeppinoSprite.animation == "suplexdash" || $PeppinoSprite.animation == "shotgun_suplexdash")):
			$PeppinoSprite.animation = "suplexdashjumpstart"
		if (Input.is_action_just_pressed("key_jump")):
			input_buffer_jump = 0
		if (is_on_floor() && input_buffer_jump < 8):
			$PeppinoSprite.animation = "suplexdashjumpstart"
			$Jump.play()
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_highjumpcloud2.tscn")
			velocity.y = -11
		if (is_on_wall()):
			if ($ObjectCheck.is_colliding() && $ObjectCheck.get_collider().is_in_group("obj_destructibles")):
				pass
			else:
				$Bump.play()
				movespeed = 0
				state = global.states.bump
				velocity.x = (-2.5 * xscale)
				velocity.y = -3
				mach2 = 0
				machslideAnim = 1
				machhitAnim = 0
				utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
		if (!utils.instance_exists("obj_slidecloud") && is_on_floor() && movespeed > 5):
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_slidecloud.tscn")
			for i in get_tree().get_nodes_in_group("obj_slidecloud"):
				if xscale == 1:
					i.sprite.flip_h = false
				elif xscale == -1:
					i.sprite.flip_h = true
	$PeppinoSprite.speed_scale = 0.35
	
func scr_player_hurt():
	if ($PeppinoSprite.animation == "hurtjump"):
		velocity.x = (xscale * movespeed)
	if ($PeppinoSprite.animation == "hurt"):
		velocity.x = ((-xscale) * movespeed)
	if (movespeed > 0):
		movespeed -= 0.1
	freefallsmash = 0
	mach2 = 0
	bounce = 0
	jumpAnim = 1
	if (is_on_floor()):
		landAnim = 0
	else:
		landAnim = 1
	jumpstop = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 0
	machhitAnim = 0
	hurted = 1
	$HurtTimer2.wait_time = 1
	$HurtTimer2.start()
	if (is_on_floor()):
		velocity.y = -4
	if (is_colliding()):
		xscale *= -1
		$SolidCheck.scale.x *= -1
		$SolidCheck2.scale.x *= -1
		$ObjectCheck.scale.x *= -1
		$WallClimbCheck.scale.x *= -1
	$PeppinoSprite.speed_scale = 0.35
	
func scr_player_mach1():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	dir = xscale
	landAnim = 0
	if (is_colliding_with_wall()):
		mach2 = 0
		state = global.states.normal
		movespeed = 0
	machhitAnim = 0
	crouchslideAnim = 1
	velocity.x = (xscale * movespeed)
	if (xscale == 1 && move == -1):
		$PeppinoSprite.animation = "mach1"
		momemtum = 0
		mach2 = 0
		movespeed = 6
		xscale = -1
	if (xscale == -1 && move == 1):
		$PeppinoSprite.animation = "mach1"
		momemtum = 0
		mach2 = 0
		movespeed = 6
		xscale = 1
	if (is_on_floor()):
		if (movespeed <= 8):
			movespeed += 0.075
		if (movespeed >= 8):
			state = global.states.mach2
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
			for i in get_tree().get_nodes_in_group("obj_jumpdust"):
				if xscale == 1:
					i.sprite.flip_h = false
				elif xscale == -1:
					i.sprite.flip_h = true
	if (!is_on_floor() && $PeppinoSprite.animation != "airdash1"):
		$PeppinoSprite.animation = "airdash2"
	if ($PeppinoSprite.animation == "airdash1" && $PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		$PeppinoSprite.animation = "airdash2"
	if (!Input.is_action_pressed("key_dash")):
		state = global.states.normal
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5):
		velocity.y /= 10
		jumpstop = 1
	if (is_on_floor() && velocity.y >= 0):
		jumpstop = 0
	if (is_colliding_with_wall()):
		state = global.states.normal
		movespeed = 0
	$PeppinoSprite.speed_scale = 0.5
	if (!utils.instance_exists("obj_dashcloud") && is_on_floor()):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_dashcloud.tscn")
		for i in get_tree().get_nodes_in_group("obj_dashcloud"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
	if (Input.is_action_just_pressed("key_grab") && Input.is_action_pressed("key_down")):
		state = global.states.freefallprep
		velocity.y = -4
	if (is_on_floor() && $PeppinoSprite.animation != "mach1" && velocity.y >= 0):
		$PeppinoSprite.animation = "mach1"
	if (Input.is_action_just_pressed("key_jump") && is_on_floor()):
		$Jump.play()
		$PeppinoSprite.animation = "airdash1"
		dir = xscale
		momemtum = 1
		velocity.y = -11
		jumpAnim = 1
	if (Input.is_action_pressed("key_down") && !is_on_floor()):
		if (shotgunAnim == 0):
			state = global.states.freefallprep
			$PeppinoSprite.animation = "bodyslamstart"
			velocity.y = -5
		#else:
			#TODO: Implement shotgun bodyslam
	scr_dotaunt()
	
func scr_player_mach2():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (character == "P"):
		if (windingAnim < 2000):
			windingAnim += 1
	velocity.x = (xscale * movespeed)
	crouchslideAnim = 1
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5):
		velocity.y /= 10
		jumpstop = 1
	if (is_on_floor() && velocity.y >= 0):
		jumpstop = 0
	if (input_buffer_jump < 8 && is_on_floor() && (!(move == 1 && xscale == -1)) && (!(move == -1 && xscale == 1))):
		$PeppinoSprite.animation = "secondjump1"
		$Jump.play()
		velocity.y = -11
	if (is_on_floor() && velocity.y >= 0):
		if (machpunchAnim == 0 && $PeppinoSprite.animation != "mach" && $PeppinoSprite.animation != "mach3" && $PeppinoSprite.animation != "machhit"):
			if ($PeppinoSprite.animation != "machhit" && $PeppinoSprite.animation != "rollgetup"):
				$PeppinoSprite.animation = "mach"
		if (machpunchAnim == 1):
			if (punch == 0):
				$PeppinoSprite.animation = "machpunch1"
			if (punch == 1):
				$PeppinoSprite.animation = "machpunch2"
			if ($PeppinoSprite.frame == 4 && $PeppinoSprite.animation == "machpunch1"):
				punch = 1
				machpunchAnim = 0
			if ($PeppinoSprite.frame == 4 && $PeppinoSprite.animation == "machpunch2"):
				punch = 0
				machpunchAnim = 0
	if (!is_on_floor()):
		machpunchAnim = 0
	if (is_on_floor()):
		if (movespeed < 12):
			movespeed += 0.1
		if (movespeed >= 12):
			movespeed = 12
			machhitAnim = 0
			state = global.states.mach3
			if ($PeppinoSprite.animation != "rollgetup"):
				$PeppinoSprite.animation = "mach4"
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
	if (Input.is_action_just_pressed("key_jump")):
		input_buffer_jump = 0
	if (Input.is_action_pressed("key_down")):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
		state = global.states.machroll
		velocity.y = 10
	if (!is_on_floor() && is_wallclimbable() && $PeppinoSprite.animation != "walljumpstart"):
		wallspeed = movespeed
		state = global.states.climbwall
	if (is_on_floor() && is_wallclimbable() && $SlopeCheck.is_colliding() && $SlopeCheck.get_collider().is_in_group("obj_slope")):
		wallspeed = movespeed
		state = global.states.climbwall
	if (is_on_floor() && is_colliding_with_wall() && (!$SlopeCheck.is_colliding() || !$SlopeCheck.get_collider().is_in_group("obj_slope"))):
		movespeed = 0
		state = global.states.normal
	if (!utils.instance_exists("obj_dashcloud") && is_on_floor()):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_dashcloud.tscn")
		for i in get_tree().get_nodes_in_group("obj_dashcloud"):
			if xscale == 1:
				i.sprite.flip_h = false
			elif xscale == -1:
				i.sprite.flip_h = true
	if (is_on_floor() && $PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && $PeppinoSprite.animation == "rollgetup"):
		$PeppinoSprite.animation = "mach"
	if (!is_on_floor() && $PeppinoSprite.animation != "secondjump2" && $PeppinoSprite.animation != "mach2jump" && $PeppinoSprite.animation != "walljumpstart" && $PeppinoSprite.animation != "walljumpend"):
		$PeppinoSprite.animation = "secondjump1"
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && $PeppinoSprite.animation == "secondjump1"):
		$PeppinoSprite.animation = "secondjump2"
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && $PeppinoSprite.animation == "walljumpstart"):
		$PeppinoSprite.animation = "walljumpend"
	if (!Input.is_action_pressed("key_dash") && move != xscale && is_on_floor()):
		state = global.states.machslide
		$MachSlide.play()
		$PeppinoSprite.animation = "machslidestart"
	if (move == (-xscale) && is_on_floor() && character == "P"):
		$MachSlideBoost.play()
		state = global.states.machslide
		$PeppinoSprite.animation = "machslideboost"
	if (move == xscale && !Input.is_action_pressed("key_dash") && is_on_floor() && character == "P"):
		state = global.states.normal
	if ($PeppinoSprite.animation == "rollgetup"):
		$PeppinoSprite.speed_scale = 0.4
	else:
		$PeppinoSprite.speed_scale = 0.65
	scr_dotaunt()
	
func scr_player_mach3():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (character == "P"):
		if (windingAnim < 2000):
			windingAnim += 1
	velocity.x = (xscale * movespeed)
	mach2 = 100
	momemtum = 1
	if (movespeed < 24 && move == xscale):
		movespeed += 0.1
		if (!utils.instance_exists("obj_crazyruneffect")):
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_crazyruneffect.tscn")
	elif (movespeed > 12 && move != xscale):
		movespeed -= 0.1
	crouchslideAnim = 1
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5):
		velocity.y /= 10
		jumpstop = 1
	if (is_on_floor() && velocity.y >= 0):
		jumpstop = 0
	if (input_buffer_jump < 8 && is_on_floor() && (!(move == 1 && xscale == -1)) && (!(move == -1 && xscale == 1))):
		$Jump.play()
		$PeppinoSprite.animation = "mach3jump"
		velocity.y = -11
	if ($PeppinoSprite.animation == "mach3jump" && $PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		$PeppinoSprite.animation = "mach4"
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && ($PeppinoSprite.animation == "rollgetup" || $PeppinoSprite.animation == "mach3hit")):
		$PeppinoSprite.animation = "mach4"
	if ($PeppinoSprite.animation == "mach2jump" && is_on_floor() && velocity.y >= 0):
		$PeppinoSprite.animation = "mach4"
	if (movespeed > 20 && $PeppinoSprite.animation != "crazyrun"):
		$PeppinoSprite.animation = "crazyrun"
	elif (movespeed <= 20 && $PeppinoSprite.animation == "crazyrun"):
		$PeppinoSprite.animation = "mach4"
	if ($PeppinoSprite.animation == "crazyrun" && !utils.instance_exists("obj_crazyrunothereffect")):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_crazyrunothereffect.tscn")
	if ($PeppinoSprite.animation == "mach4"):
		$PeppinoSprite.speed_scale = 0.4
	if ($PeppinoSprite.animation == "crazyrun"):
		$PeppinoSprite.speed_scale = 0.75
	if ($PeppinoSprite.animation == "rollgetup" || $PeppinoSprite.animation == "mach3hit"):
		$PeppinoSprite.speed_scale = 0.4
	if (Input.is_action_just_pressed("key_jump")):
		input_buffer_jump = 0
	if (Input.is_action_pressed("key_up")):
		$PeppinoSprite.animation = "superjumpprep"
		state = global.states.Sjumpprep
		velocity.x = 0
	if (!Input.is_action_pressed("key_dash") && is_on_floor() && character == "P"):
		$PeppinoSprite.animation = "machslidestart"
		$MachSlide.play()
		state = global.states.machslide
	if (move == (-xscale) && is_on_floor() && character == "P"):
		$PeppinoSprite.animation = "machslideboost3"
		$MachSlideBoost.play()
		state = global.states.machslide
	if (Input.is_action_pressed("key_down")):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
		state = global.states.machroll
		velocity.y = 10
	if (!is_on_floor() && is_wallclimbable()):
		wallspeed = 10
		state = global.states.climbwall
	if (is_on_floor() && is_wallclimbable() && $SlopeCheck.is_colliding() && $SlopeCheck.get_collider().is_in_group("obj_slope")):
		wallspeed = 10
		state = global.states.climbwall
	if (is_on_floor() && (is_colliding_with_wall() && $PeppinoSprite.animation != "machslideboost" && $PeppinoSprite.animation != "machslideboost3") && (!$SlopeCheck.is_colliding() || !$SlopeCheck.get_collider().is_in_group("obj_slope"))):
		$PeppinoSprite.animation = "hitwall"
		$Groundpound.play()
		$Bump.play()
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 20
			i.shake_mag_acc = (40 / 20)
		velocity.x = 0
		$PeppinoSprite.speed_scale = 0.35
		for i in get_tree().get_nodes_in_group("obj_baddie"):
			if (i.screenvisible):
				i.stun = true
				i.ministun = false
				i.velocity.y = -5
				i.velocity.x = 0
		state = global.states.bump
		velocity.x = (-2.5 * xscale)
		velocity.y = -3
		mach2 = 0
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
	if (!utils.instance_exists("obj_chargeeffect")):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_chargeeffect.tscn")
	if (!utils.instance_exists("obj_superdashcloud") && is_on_floor()):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_superdashcloud.tscn")
	scr_dotaunt()
	
func scr_player_machfreefall():
	pass
	
func scr_player_machslide():
	velocity.x = (xscale * movespeed)
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (movespeed >= 0):
		movespeed -= 0.4
	if ($PeppinoSprite.animation == "machslidestart" && $PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		$PeppinoSprite.animation = "machslide"
	$PeppinoSprite.speed_scale = 0.35
	landAnim = 0
	if (movespeed <= 0 && ($PeppinoSprite.animation == "machslide" || $PeppinoSprite.animation == "crouchslide")):
		state = global.states.normal
		if ($PeppinoSprite.animation == "machslide"):
			machslideAnim = 1
		movespeed = 0
	if (is_colliding_with_wall() && ($PeppinoSprite.animation == "machslide" || $PeppinoSprite.animation == "machslidestart")):
		velocity.x = ((-xscale) * 2.5)
		velocity.y = -4
		state = global.states.bump
		$PeppinoSprite.frame = 4
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && $PeppinoSprite.animation == "machslideboost"):
		velocity.x = 0
		$SolidCheck.scale.x *= -1
		$SolidCheck2.scale.x *= -1
		$ObjectCheck.scale.x *= -1
		$WallClimbCheck.scale.x *= -1
		xscale *= -1
		movespeed = 8
		state = global.states.mach2
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && $PeppinoSprite.animation == "machslideboost3"):
		velocity.x = 0
		$PeppinoSprite.animation = "mach4"
		$SolidCheck.scale.x *= -1
		$SolidCheck2.scale.x *= -1
		$ObjectCheck.scale.x *= -1
		$WallClimbCheck.scale.x *= -1
		xscale *= -1
		movespeed = 12
		state = global.states.mach3
	if ($PeppinoSprite.animation == "crouchslide" && movespeed == 0 && is_on_floor()):
		facehurt = 1
		state = global.states.normal
		$PeppinoSprite.animation = "facehurtup"
	if (mach2 == 0):
		if (!utils.instance_exists("obj_slidecloud") && is_on_floor()):
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_slidecloud.tscn")
			for i in get_tree().get_nodes_in_group("obj_slidecloud"):
				if xscale == 1:
					i.sprite.flip_h = false
				elif xscale == -1:
					i.sprite.flip_h = true
	elif (mach2 >= 35):
		if (!utils.instance_exists("obj_dashcloud") && is_on_floor()):
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_dashcloud.tscn")
			for i in get_tree().get_nodes_in_group("obj_dashcloud"):
				if xscale == 1:
					i.sprite.flip_h = false
				elif xscale == -1:
					i.sprite.flip_h = true
	elif (mach2 >= 100):
		if (!utils.instance_exists("obj_dashcloud2") && is_on_floor()):
			utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_dashcloud2.tscn")
			for i in get_tree().get_nodes_in_group("obj_dashcloud2"):
				if xscale == 1:
					i.sprite.flip_h = false
				elif xscale == -1:
					i.sprite.flip_h = true
	
func scr_player_climbwall():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (windingAnim < 200):
		windingAnim += 1
	suplexmove = 0
	velocity.y = (-wallspeed)
	if (wallspeed < 24 && move == xscale):
		wallspeed += 0.05
	crouchslideAnim = 1
	$PeppinoSprite.animation = "climbwall"
	if ((!Input.is_action_pressed("key_dash") && character == "P") || (move != xscale && move != 0)):
		state = global.states.normal
		movespeed = 0
	if (is_on_ceiling()):
		$PeppinoSprite.animation = "superjumpland"
		$Groundpound.play()
		state = global.states.Sjumpland
		machhitAnim = 0
	if (!is_collding_wallclimb()):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
		velocity.y = 0
		if (movespeed >= 8):
			state = global.states.mach2
		if (movespeed >= 12):
			state = global.states.mach3
			$PeppinoSprite.animation = "mach4"
	if (Input.is_action_just_pressed("key_jump")):
		movespeed = 8
		$PeppinoSprite.animation = "walljumpstart"
		velocity.y = -11
		xscale *= -1
		jumpstop = 0
		state = global.states.mach2
	if ((is_on_floor() && wallspeed <= 0) || wallspeed <= 0):
		state = global.states.jump
		$PeppinoSprite.animation = "fall"
	$PeppinoSprite.speed_scale = 0.6
	if (!utils.instance_exists("obj_cloudeffect")):
		utils.instance_create(position.x, (position.y + 43), "res://Objects/Visuals/obj_cloudeffect.tscn")
	
func scr_player_machroll():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	velocity.x = (xscale * movespeed)
	mach2 = 100
	machslideAnim = 1
	if ($WallClimbCheck.is_colliding() && $WallClimbCheck.get_collider().is_in_group("obj_solid") && is_on_wall()):
		$Bump.play()
		velocity.x = 0
		$PeppinoSprite.speed_scale = 0.35
		state = global.states.bump
		velocity.x = (-2.5 * xscale)
		velocity.y = -3
		mach2 = 0
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_bumpeffect.tscn")
	if (!utils.instance_exists("obj_cloudeffect") && is_on_floor()):
		utils.instance_create(position.x, (position.y + 43), "res://Objects/Visuals/obj_cloudeffect.tscn")
	if is_on_floor():
		$PeppinoSprite.animation = "machroll"
	elif $PeppinoSprite.animation != "dive":
		$PeppinoSprite.animation = "dive"
		velocity.y = 10
	$PeppinoSprite.speed_scale = 0.8
	if (!Input.is_action_pressed("key_down")):
		$RollGetUp.play()
		state = global.states.mach2
		if (character == "P"):
			$PeppinoSprite.animation = "rollgetup"
		
	
func scr_player_tumble():
	velocity.x = (xscale * movespeed)
	if ($PeppinoSprite.animation == "tumblestart"):
		movespeed = 6
	else:
		movespeed = 14
	for i in get_slide_count():
		var collision = get_slide_collision(i)
		if !collision.collider.is_in_group("obj_slope") && $PeppinoSprite.animation == "tumblestart" && $PeppinoSprite.frame < 11:
			$PeppinoSprite.frame = 11
	if ($PeppinoSprite.animation == "tumblestart" && $PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		$PeppinoSprite.animation = "tumble"
	if ($WallClimbCheck.is_colliding() && $WallClimbCheck.get_collider().is_in_group("obj_solid") && is_on_wall()):
		$Tumble4.play()
		velocity.x = 0
		movespeed = 0
		$PeppinoSprite.animation = "tumbleend"
		state = global.states.bump
	if Input.is_action_just_pressed("key_jump"):
		input_buffer_jump = 0
	if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5 && stompAnim == 0):
		velocity.y /= 2
		jumpstop = 1
	if (is_on_floor() && velocity.y >= 0):
		jumpstop = 0
	if (input_buffer_jump < 8 && is_on_floor() && velocity.x != 0):
		velocity.y = -9
	$PeppinoSprite.speed_scale = 0.35
	
func scr_player_titlescreen():
	global.targetDoor = "A"
	if ($PeppinoSprite.animation == "pepcooter" && (!utils.instance_exists("obj_superdashcloud"))):
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_superdashcloud.tscn")
	$PeppinoSprite.speed_scale = 0.35
	
func scr_player_Sjump():
	velocity.x = 0
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 0
	machhitAnim = 0
	if ($PeppinoSprite.animation == "superjump"):
		velocity.y = -15
	if (is_on_ceiling()):
		if ($PeppinoSprite.animation == "superjump"):
			$PeppinoSprite.animation = "superjumpland"
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 10
			i.shake_mag_acc = (30 / 30)
		for i in get_tree().get_nodes_in_group("obj_baddie"):
			if (i.screenvisible):
				if (i.is_on_floor()):
					i.velocity.y = -7
		$Groundpound.play()
		state = global.states.Sjumpland
		machhitAnim = 0
	if (Input.is_action_just_pressed("key_dash")):
		movespeed = 12
		machhitAnim = 0
		state = global.states.mach3
		$PeppinoSprite.animation = "mach4"
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_jumpdust.tscn")
	$PeppinoSprite.speed_scale = 0.5
	
func scr_player_Sjumpland():
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	machslideAnim = 1
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 0
	machhitAnim = 0
	movespeed = 0
	velocity.y = 0
	velocity.x = 0
	if ($PeppinoSprite.frame == 6):
		$PeppinoSprite.animation = "machfreefall"
		state = global.states.jump
		jumpAnim = 0
	
func scr_player_Sjumpprep():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	mach2 = 0
	if ($PeppinoSprite.animation == "superjumpprep"):
		velocity.x = (xscale * movespeed)
		if (movespeed >= 0):
			movespeed -= 0.8
	if ($PeppinoSprite.animation == "superjumppreplight" || $PeppinoSprite.animation == "superjumpright" || $PeppinoSprite.animation == "superjumpleft"):
		velocity.x = (move * 2)
	if (character == "P"):
		if ($PeppinoSprite.animation != "superjumpprep"):
			if (sign(velocity.x) == 0):
				$PeppinoSprite.animation = "superjumppreplight"
			if (sign(velocity.x) == 1):
				if (xscale == 1):
					$PeppinoSprite.animation = "superjumpright"
				if (xscale == -1):
					$PeppinoSprite.animation = "superjumpleft"
			if (sign(velocity.x) == -1):
				if (xscale == 1):
					$PeppinoSprite.animation = "superjumpleft"
				if (xscale == -1):
					$PeppinoSprite.animation = "superjumpright"
	jumpAnim = 1
	landAnim = 0
	machslideAnim = 1
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1 && $PeppinoSprite.animation == "superjumpprep"):
		$PeppinoSprite.animation = "superjumppreplight"
	if (!Input.is_action_pressed("key_up") && ($PeppinoSprite.animation == "superjumppreplight" || $PeppinoSprite.animation == "superjumpleft" || $PeppinoSprite.animation == "superjumpright")):
		$SuperJumpRelease.play()
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_explosioneffect.tscn")
		$PeppinoSprite.animation = "superjump"
		state = global.states.Sjump
		velocity.y = -15
	if (!$SuperJumpHold.playing):
		$SuperJumpHold.play()
	$PeppinoSprite.speed_scale = 0.35
	
func scr_player_fireass():
	pass
	
func scr_player_timesup():
	pass
	
func scr_player_gameover():
	pass

func scr_player_victory():
	velocity.x = 0
	mach2 = 0
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	machhitAnim = 0
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		$PeppinoSprite.speed_scale = 0
	else:
		$PeppinoSprite.speed_scale = 0.35
	
func scr_player_grab():
	grav = 0.5
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (is_on_floor()):
		if (dir != xscale && $PeppinoSprite.animation != "swingding"):
			dir = xscale
			movespeed = 2
			facehurt = 0
		jumpstop = 0
		anger = 100
		velocity.x = (move * movespeed)
		if (!heavy):
			if (move != 0):
				if (movespeed < 6):
					movespeed += 0.5
				elif (floor(movespeed) == 6):
					movespeed = 6 
			else:
				movespeed = 0
			if (movespeed > 6):
				movespeed -= 0.1
		else:
			if (move != 0):
				if (movespeed < 4):
					movespeed += 0.25
				elif (floor(movespeed) == 4):
					movespeed = 4
			else:
				movespeed = 0
			if (movespeed > 4):
				movespeed -= 0.1
		if (move != 0 && $PeppinoSprite.animation != "swingding"):
			xscale = move
		if (move != 0):
			if (movespeed < 3 && move != 0):
				$PeppinoSprite.speed_scale = 0.35
			elif (movespeed > 3 && movespeed < 6):
				$PeppinoSprite.speed_scale = 0.45
			else:
				$PeppinoSprite.speed_scale = 0.6
		else:
			$PeppinoSprite.speed_scale = 0.35
	if (!is_on_floor()):
		if (dir != xscale && $PeppinoSprite.animation != "swingding"):
			dir = xscale
			movespeed = 2
			facehurt = 0
		if (move != xscale):
			movespeed = 2
		if (momemtum == 0):
			velocity.x = (move * movespeed)
		else:
			velocity.x = (xscale * movespeed)
		if (move != xscale && momemtum == 1 && movespeed != 0):
			movespeed -= 0.05
		if (movespeed == 0):
			momemtum = 0
		if (move != 0 && movespeed < 6):
			movespeed += 0.5
		if (movespeed > 6):
			movespeed -= 0.5
		if ($WallClimbCheck.is_colliding() && $WallClimbCheck.get_collider().is_in_group("obj_solid") && is_on_wall()):
			movespeed = 0
		if (dir != xscale && $PeppinoSprite.animation != "swingding"):
			dir = xscale
			movespeed = 2
			facehurt = 0
		if (move == (-xscale)):
			mach2 = 0
			momemtum = 0
		landAnim = 1
		if (!Input.is_action_pressed("key_jump") && jumpstop == 0 && velocity.y < 0.5 && stompAnim == 0):
			velocity.y /= 10
			jumpstop = 1
		if (ladderbuffer > 0):
			ladderbuffer -= 1
		if (is_on_ceiling() && jumpstop == 0 && jumpAnim == 1):
			velocity.y = grav
			jumpstop = 1
		if (move != 0 && $PeppinoSprite.animation != "swingding"):
			xscale = move
	if (Input.is_action_just_pressed("key_jump")):
		input_buffer_jump = 0
	if (is_on_floor() && input_buffer_jump < 8 && !Input.is_action_pressed("key_down") && !Input.is_action_pressed("key_dash") && velocity.y >= 0 && $PeppinoSprite.animation != "swingding"):
		$Jump.play()
		$PeppinoSprite.animation = "haulingjump"
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_highjumpcloud2.tscn")
		if (!heavy):
			velocity.y = -11
		else:
			velocity.y = -6
	if (is_on_floor() && move != 0 && $PeppinoSprite.animation == "haulingidle"):
		$PeppinoSprite.animation = "haulingwalk"
	elif (is_on_floor() && move == 0 && $PeppinoSprite.animation == "haulingwalk"):
		$PeppinoSprite.animation = "haulingidle"
	if ($PeppinoSprite.animation == "haulingstart" && $PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		$PeppinoSprite.animation = "haulingidle"
	if (($PeppinoSprite.animation == "haulingjump" && $PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1) || (!is_on_floor() && ($PeppinoSprite.animation == "haulingwalk" || $PeppinoSprite.animation == "haulingidle"))):
		$PeppinoSprite.animation = "haulingfall"
	if (is_on_floor() && velocity.y >= 0 && ($PeppinoSprite.animation == "haulingfall" || $PeppinoSprite.animation == "haulingjump")):
		$PeppinoSprite.animation = "haulingland"
		movespeed = 2
	if ($PeppinoSprite.animation == "haulingland" && $PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		$PeppinoSprite.animation = "haulingidle"
	if (move != 0 && move != lastmove && swingdingbuffer < 300):
		lastmove = move
		swingdingbuffer += 50
	if (swingdingbuffer > 0):
		swingdingbuffer -= 1
	if ($PeppinoSprite.animation == "swingding" && swingdingbuffer < 150):
		state = global.states.normal
	if (swingdingbuffer > 300 && $PeppinoSprite.animation != "swingding"):
		$PeppinoSprite.animation = "swingding"
	if (Input.is_action_just_pressed("key_dash") || Input.is_action_just_pressed("key_grab")):
		if (move != 0):
			move = xscale
		state = global.states.finishingblow
		if ($PeppinoSprite.animation == "swingding"):
			$PeppinoSprite.animation = "swingdingend"
		elif (!Input.is_action_pressed("key_up")):
			var rng = utils.randi_range(1, 5)
			if (rng == 1):
				$PeppinoSprite.animation = "finishingblow1"
			elif (rng == 2):
				$PeppinoSprite.animation = "finishingblow2"
			elif (rng == 3):
				$PeppinoSprite.animation = "finishingblow3"
			elif (rng == 4):
				$PeppinoSprite.animation = "finishingblow4"
			elif (rng == 5):
				$PeppinoSprite.animation = "finishingblow5"
		elif (Input.is_action_pressed("key_up")):
			$PeppinoSprite.animation = "uppercutfinishingblow"
		if ($PeppinoSprite.animation == "finishingblow1" || $PeppinoSprite.animation == "finishingblow2" || $PeppinoSprite.animation == "finishingblow3" || $PeppinoSprite.animation == "finishingblow4" || $PeppinoSprite.animation == "finishingblow5" || $PeppinoSprite.animation == "uppercutfinishingblow"):
			if (!$PeppinoSprite.flip_h):
				$PeppinoSprite.position.x = -20
			elif ($PeppinoSprite.flip_h):
				$PeppinoSprite.position.x = -80
		velocity.x = 0
		movespeed = 0
	if (Input.is_action_pressed("key_down") && !is_on_floor()):
		$PeppinoSprite.animation = "piledriver"
		velocity.y = -6
		state = global.states.superslam
		$PeppinoSprite.speed_scale = 0.35
	if (!utils.instance_exists("obj_cloudeffect") && is_on_floor() && move != 0 && (floor($PeppinoSprite.frame) == 4 || floor($PeppinoSprite.frame) == 10)):
		utils.instance_create(position.x, (position.y + 43), "res://Objects/Visuals/obj_cloudeffect.tscn")
	if (Input.is_action_pressed("key_down") && is_on_floor()):
		state = global.states.crouch
		landAnim = 0
		crouchAnim = 1
		idle = 0
	if ($PeppinoSprite.animation != "swingding"):
		$PeppinoSprite.speed_scale = 0.35
	else:
		$PeppinoSprite.speed_scale = (swingdingbuffer / 600)
	
func scr_player_superslam():
	var move = 0
	if ($PeppinoSprite.animation == "piledriver"):
		move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
		velocity.x = (move * movespeed)
	else:
		move = 0
		velocity.x = 0
	if (is_on_floor() && $PeppinoSprite.animation == "piledriver" && velocity.y >= 0):
		$Groundpound.play()
		$PeppinoSprite.animation = "piledriverland"
		jumpAnim = 1
		for i in get_tree().get_nodes_in_group("obj_camera"):
			i.shake_mag = 20
			i.shake_mag_acc = (40 / 30)
		velocity.x = 0
		bounce = 0
		var effectid = utils.instance_create(global_position.x, global_position.y + 35, "res://Objects/Visuals/obj_bangeffect.tscn")
		effectid.scale.x = xscale
		utils.instance_create(position.x, position.y, "res://Objects/Visuals/obj_landcloud.tscn")
		freefallstart = 0
		for i in utils.get_tree().get_nodes_in_group("obj_baddie"):
			if (i.is_on_floor() && i.screenvisible):
				i.velocity.y = -7
				i.velocity.x = 0
	jumpAnim = 1
	landAnim = 0
	machslideAnim = 1
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	if (move != 0):
		if (movespeed < 6):
			movespeed += 0.5
		elif (floor(movespeed) == 6):
			movespeed = 6
	else:
		movespeed = 0
	if (movespeed > 6):
		movespeed -= 0.1
	if (character == "N" && move != 0):
		xscale = move
	$PeppinoSprite.speed_scale = 0.35
	
func scr_player_finishingblow():
	velocity.x = (xscale * movespeed)
	if (movespeed > 0):
		movespeed -= 0.5
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		state = global.states.normal
	if ($PeppinoSprite.frame == 6 && (!utils.instance_exists("obj_swordhitbox"))):
		utils.playsound("Punch")
		utils.playsound("KillingBlow")
		utils.instance_create((global_position.x + 100), (global_position.y + 50), "res://Objects/Hitboxes/obj_swordhitbox.tscn")
	if ($PeppinoSprite.frame == 0 && (!utils.instance_exists("obj_swordhitbox")) && $PeppinoSprite.animation == "swingdingend"):
		utils.playsound("KillingBlow")
		utils.instance_create((global_position.x + 100), (global_position.y + 50), "res://Objects/Hitboxes/obj_swordhitbox.tscn")
	$PeppinoSprite.speed_scale = 0.35
	landAnim = 0
	
func scr_player_ladder():
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 0
	machhitAnim = 0
	jumpstop = 0
	movespeed = 0
	velocity.x = 0
	if Input.is_action_pressed("key_up"):
		$PeppinoSprite.animation = "laddermove"
		velocity.y = -2
		$PeppinoSprite.speed_scale = 0.35
	elif Input.is_action_pressed("key_down"):
		$PeppinoSprite.animation = "ladderdown"
		velocity.y = 6
		$PeppinoSprite.speed_scale = -0.35
	else:
		$PeppinoSprite.animation = "ladder"
		velocity.y = 0
	mach2 = 0
	if (!$LadderCheck.is_colliding()):
		landAnim = 0
		jumpAnim = 0
		state = global.states.normal
		velocity.y = 0
	if (Input.is_action_just_pressed("key_jump")):
		$PeppinoSprite.animation = "jump"
		ladderbuffer = 20
		jumpAnim = 1
		state = global.states.jump
		velocity.y = -9
	if (Input.is_action_pressed("key_down") && is_on_floor()):
		state = global.states.normal
		
func scr_player_tackle():
	mach2 = 0
	velocity.x = ((-xscale) * movespeed)
	if (movespeed > 0):
		movespeed -= 0.5
	jumpAnim = 1
	landAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	if ($PeppinoSprite.frame == $PeppinoSprite.frames.get_frame_count($PeppinoSprite.animation) - 1):
		state = global.states.normal
	$PeppinoSprite.speed_scale = 0.35
	
func scr_playerreset():
	if (utils.instance_exists("obj_endlevelfade")):
		for i in get_tree().get_nodes_in_group("obj_endlevelfade"):
			i.queue_free()
	global.secretfound = 0
	global.hurtcounter = 0
	for i in get_tree().get_nodes_in_group("obj_tv"):
		i.shownranka = false
		i.shownrankb = false
		i.shownrankc = false
	for i in get_tree().get_nodes_in_group("obj_music"):
		i.musicnode.stop()
	if (utils.instance_exists("obj_timesup")):
		for i in get_tree().get_nodes_in_group("obj_timesup"):
			i.queue_free()
	global.seconds = 59
	global.minutes = 1
	state = global.states.normal
	visible = true
	targetLevel = ""
	targetRoom = ""
	global.saveroom.clear()
	global.baddieroom.clear()
	$HurtTimer.stop()
	$HurtTimer2.stop()
	grav = 0.5
	velocity.x = 0
	velocity.y = 0
	xscale = 1
	yscale = 1
	position.x = backtohubstartx
	position.y = backtohubstarty
	shotgunAnim = 0
	steppy = 0
	jumpstop = 0
	for i in get_tree().get_nodes_in_group("obj_camera"):
		i.ded = 0
	global.panic = false
	jumpAnim = 1
	landAnim = 0
	machslideAnim = 0
	moveAnim = 1
	stopAnim = 1
	crouchslideAnim = 1
	crouchAnim = 1
	machhitAnim = 0
	stompAnim = 0
	inv_frames = 0
	hurted = 0
	mach2 = 0
	input_buffer_jump = 8
	input_buffer_secondjump = 8
	input_buffer_highjump = 8
	global.key_inv = 0
	global.shroomfollow = false
	global.cheesefollow = false
	global.tomatofollow = false
	global.sausagefollow = false
	global.pineapplefollow = false
	global.collect = 0
	global.treasure = false
	global.combo = 0
	global.combotime = 0
	global.hit = 0
	bounce = 0
	idle = 0
	superslam = 0
	attacking = 0
	machpunchAnim = 0
	punch = 0
	instakillmove = 0
	windingAnim = 0
	facestompAnim = 0
	ladderbuffer = 0
	toomuchalarm1 = 0
	toomuchalarm2 = 0
	idleanim = 0
	momemtum = 0
	cutscene = false
	grabbing = 0
	dir = xscale
	fallinganimation = 0
	bombpeptimer = 100
	suplexmove = 0
	anger = 0
	angry = 0

func scr_playersounds():
	var move = ((-int(Input.is_action_pressed("key_left"))) + int(Input.is_action_pressed("key_right")))
	if (state == global.states.mach1 && !$Mach1.playing && is_on_floor()):
		$Mach1.play()
	elif (state != global.states.mach1 || !is_on_floor() || move == (-xscale)):
		$Mach1.stop()
	if (($PeppinoSprite.animation == "mach" || state == global.states.climbwall) && !$Mach2.playing):
		$Mach2.play()
	elif ($PeppinoSprite.animation != "mach" && state != global.states.climbwall):
		$Mach2.stop()
	if ((state == global.states.mach3 || $PeppinoSprite.animation == "machslideboost3") && $PeppinoSprite.animation != "crazyrun" && !$Mach3.playing):
		$Mach3.play()
	elif ((state != global.states.mach3 && $PeppinoSprite.animation != "machslideboost3") || $PeppinoSprite.animation == "crazyrun"):
		$Mach3.stop()
	if ($PeppinoSprite.animation == "crazyrun" && !$Mach4.playing):
		$Mach4.play()
	elif ($PeppinoSprite.animation != "crazyrun"):
		$Mach4.stop()
	if (state != global.states.Sjumpprep && $SuperJumpPrep.playing):
		$SuperJumpPrep.stop()
	if (state != global.states.Sjumpprep && $SuperJumpHold.playing):
		$SuperJumpHold.stop()
	if ($PeppinoSprite.animation == "tumblestart" && !$Tumble1.playing && $PeppinoSprite.frame < 11):
		$Tumble1.play()
	if ($PeppinoSprite.animation == "tumblestart" && $PeppinoSprite.frame == 11 && !$Tumble2.playing):
		$Tumble2.play()
		$Tumble1.stop()
	if (($PeppinoSprite.animation == "tumble" || $PeppinoSprite.animation == "machroll") && !$Tumble3.playing):
		$Tumble3.play()
	if (state != global.states.tumble && $PeppinoSprite.animation != "machroll"):
		$Tumble1.stop()
		$Tumble2.stop()
		$Tumble3.stop()
	if ($SuplexDash.playing && state != global.states.handstandjump):
		$SuplexDash.stop()

func _on_HurtTimer_timeout():
	if (state == global.states.hurt):
		state = global.states.normal
		movespeed = 0

func _on_HurtTimer2_timeout():
	hurted = 0
	inv_frames = 0
